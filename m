From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [PATCH v2 0/5] Fixes for config file parsing
Date: Wed, 14 Mar 2018 12:41:07 -0500
Message-ID: <20180314174107.GG14513@octiron.msp.redhat.com>
References: <20180307232620.15746-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20180307232620.15746-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, Mar 08, 2018 at 12:26:15AM +0100, Martin Wilck wrote:
> This series was motivated by the real-world problem that a user couldn't
> figure out how to write a blacklist entry for a device called '1.8" SSD'.
> Fixing this for good turned out to be a little tricky, therefore I also
> added a test suite.
> 
> Changes since v1:
>  - fixed a problem with parsing the command strings from cli handlers.
> 

Reviewed-by: Benjmain Marzinski <bmarzins@redhat.com>

for the set.

> Martin Wilck (5):
>   tests: add unit tests for config file parser
>   libmultipath: config parser: don't strip whitepace between quotes
>   libmultipath: config parser: Allow '"' in strings
>   libmultipath: config parser: fix corner case for double quotes
>   multipath.conf(5): improve syntax documentation
> 
>  libmultipath/parser.c      |  60 ++++--
>  libmultipath/parser.h      |   1 +
>  multipath/multipath.conf.5 |  17 ++
>  multipathd/cli.c           |   2 +-
>  tests/Makefile             |   2 +-
>  tests/globals.c            |   1 +
>  tests/parser.c             | 474 +++++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 540 insertions(+), 17 deletions(-)
>  create mode 100644 tests/parser.c
> 
> -- 
> 2.16.1
