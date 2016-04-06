package Local::Hackathon::Worker::Opengraph;

use Mouse::Role;

use HTML::Parser ();
use DDP;

has '+source',       default => 'og';
has '+destination',  default => 'view';


sub process{
    my $self = shift;
    my $task = shift;
    my $HTML = $task->{HTML};
    my $og_hash = {};
    my $start = sub{
        my $name = shift;
        my $attr = shift;
        if($name eq "meta" and defined($attr->{property}) and ($attr->{property} =~ /^og\:(.*)$/)){
            $og_hash->{$1} = $attr->{content};
        }
    };
    
    my $p = HTML::Parser->new(api_version => 3, start_h => [$start, "tagname, attr"]);
    $p->parse($HTML);
    $p->eof;
    $task->{og} = $og_hash;
    return $task;
    
}

1;