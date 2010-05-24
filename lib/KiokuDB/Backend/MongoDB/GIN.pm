package KiokuDB::Backend::MongoDB::GIN;

use Moose;

use namespace::autoclean;

extends qw(KiokuDB::Backend::MongoDB);

with qw(
    KiokuDB::Backend::Role::Query::GIN
    Search::GIN::Extract::Delegate
);
#has '+inline_data' => ( default => 1 );

around 'serialize' => sub {
    my $orig = shift;
    my $self = shift;
    my $entry = shift;
    my $data = $self->$orig($entry, @_);
    
    if ($self->extract) {
        if (!$entry->deleted and $entry->object) {
            my @keys = $self->extract_values( $entry->object, entry => $entry );
            $data->{'kiokuextract'} = \@keys;
        }
    }
    $data;
};

sub search {
    my ( $self, $query, @args ) = @_;
    return unless ref $self;
    my %spec = $query->extract_values($self);
    use Data::Dump;
    if (!$spec{method} eq 'all') {
        confess("unknown method " . $spec{method} . " in search");
    }
    my $proto = {
        'kiokuextract' => { '$in' => $spec{values} },
    };
    return $self->_proto_search($proto);
}
sub fetch_entry {
    warn "fetch_entry:\n\t" . join ("\n\t", @_);
    
}

sub insert_entry {
    warn "insert_entry:\n\t" . join ("\n\t", @_);
    
}

sub remove_ids {
    warn "remove ids:\n\t" . join ("\n\t", @_);
}


1;