From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: Re: [PATCH 0/4] multipath-tools unit test fixups
Date: Fri, 13 Mar 2020 12:52:43 -0500
Message-ID: <20200313175243.GQ30153@octiron.msp.redhat.com>
References: <20200302222025.21022-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200302222025.21022-1-mwilck@suse.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Content-Disposition: inline
To: mwilck@suse.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Mar 02, 2020 at 11:20:21PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> Hi Christophe, hi Ben,
> 
> as announced in my previous post, here's a set of minor fixups for the
> unit tests. The README.md should have been created long ago. My main
> issue is that I'd prefer not to have a file under git control that is
> likely to be customized in every developer's environment and needs
> to be stashed away before every serious git work.
> 
> Martin Wilck (4):
>   Remove tests/directio_test_dev
>   tests/Makefile: allow setting DIO_TEST_DEV in the environment
>   tests/Makefile: add test_clean target
>   tests: add README.md

Sorry for the delay. ACK for the set.

-Ben


> 
>  tests/Makefile          | 13 +++++---
>  tests/README.md         | 72 +++++++++++++++++++++++++++++++++++++++++
>  tests/directio_test_dev |  4 ---
>  3 files changed, 81 insertions(+), 8 deletions(-)
>  create mode 100644 tests/README.md
>  delete mode 100644 tests/directio_test_dev
> 
> -- 
> 2.25.0
