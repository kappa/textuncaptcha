#! /usr/bin/perl
use Modern::Perl;

use WebService::Simple;
use Data::Dump;
use List::Util qw/first/;

my @res = (
    [ qr/(\d+)(?:th|st|rd) letter in the word "(\w+)" is/ =>
        sub {
            substr $2, $1 - 1, 1;
        }
    ],
    [ qr/(\d+).*(\d+)(?:th|st|rd) digit/ =>
        sub {
            substr $1, $2 - 1, 1;
        }
    ],
    [ qr/(\d+)(?:th|st|rd) digit in.* (\d+)/ =>
        sub {
            substr $2, $1 - 1, 1;
        }
    ],
    [ qr/digit is (\d+)(?:th|st|rd) in.* (\d+)/ =>
        sub {
            substr $2, $1 - 1, 1;
        }
    ],
    [ qr/is called (\w+), .* name\?/ =>
        sub { $1 }
    ],
    [ qr/What is (\w+)'s? name\?/ =>
        sub { $1 }
    ],
    [ qr/(\w+)'s? name is\?/ =>
        sub { $1 }
    ],
    [ qr/name of (\w+) is/ =>
        sub { $1 }
    ],
    [ qr/(\d+) (?:plus|\+|add) (\d+)/ =>
        sub { $1 + $2 }
    ],
    [ qr/(\d+) (?:minus|\-) (\d+)/ =>
        sub { $1 - $2 }
    ],
    [ qr/\w+ is (\w+) .* what colou?r\?/ =>
        sub { $1 }
    ],
    [ qr/colou?r\? of a (\w+)/ =>
        sub { $1 }
    ],
    [ qr/(?:The )?(\w+) \w+ .* what colou?r\?/ =>
        sub { $1 }
    ],
);

my $svc = WebService::Simple->new(
    base_url => 'http://textcaptcha.com/api/6a75jko68bggw0sssgccscc0w/'
);

my $cap;
my ($total, $matched) = (0, 0);

while (my $res = $svc->get->parse_response) {
    $total++;
    $cap = $res->{question};
    say $cap;
    if (my $m = first { $cap =~ $_->[0] } @res) {
        $cap =~ $m->[0] and say $m->[1]->();
        $matched++;
    };
    say " -- rate: $matched/$total";
    <STDIN>;
}
