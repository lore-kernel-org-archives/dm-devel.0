From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-cache fs corruption
Date: Wed, 13 Nov 2013 14:32:37 -0500
Message-ID: <20131113193237.GB18107@redhat.com>
References: <CALwk7=z+Xc8Xrcw5jo8DtKwT9KS2gQMumtaHTws0w4+VDs2NwQ@mail.gmail.com>
	<20131113131022.GA13882@debian>
	<CALwk7=xhJBoxyvM4yw0DwFGQoOmhAxp1p9C0oid_Wh4tzxSf5w@mail.gmail.com>
	<20131113144112.GF13882@debian>
	<CALwk7=zWxL1QD3_pujA-QpWOCLLbJKT31p5HqTrzJwYPETh26g@mail.gmail.com>
	<CALwk7=xi2NBOE+bGcoygtsqFYzSE8a7DsC7p7MCRd06QU6jihQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALwk7=xi2NBOE+bGcoygtsqFYzSE8a7DsC7p7MCRd06QU6jihQ@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Vladimir Smolensky <arizal@gmail.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 13 2013 at 11:29am -0500,
Vladimir Smolensky <arizal@gmail.com> wrote:

> Hello,
> I'm compiling the for-linus branch, it shows 3.12.0-rc5, that's ok right?

Yes, that branch is based on v3.12-rc5.  Once the branch is made it is
best not to rebase (Linus prefers that, unless there is a strong reason
to rebase).

Chances are there is still a 64bit bug that is causing truncation of
values to 32bit.  So I wouldn't expect the latest code to help your
particular situation but it doesn't hurt to use the latest.

> Where can I get cache_restore, cache_dump, etc. and info how to use them.

Those tools are part of this project:
https://github.com/jthornber/thin-provisioning-tools

There are man pages for each utility (in the man8 subdir).
