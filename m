From: Julian Andres Klode <julian.klode@canonical.com>
Subject: Re: hi . I just found out that `kpartx -d
 /full/path/to/myimg.img` does not release the partition mappings as
 expected.
Date: Mon, 9 Jul 2018 09:33:24 +0200
Message-ID: <20180709073324.eshxipbd22yrwu4p@jak-t480s>
References: <CAE4vF2eqMJWE4DpFTL7nNPs6Yns5PuO6-LzZAuwKO34pE3MWtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAE4vF2eqMJWE4DpFTL7nNPs6Yns5PuO6-LzZAuwKO34pE3MWtw@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: solsTiCe d'Hiver <solstice.dhiver@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Jul 04, 2018 at 02:26:16PM +0200, solsTiCe d'Hiver wrote:
> I had to do it manually with `dmsetup remove loop?p?`
> 
> I am using kernel 4.15.0-24-generic on ubuntu 18.04.
> 
> I don't know if it's a bug introduce by ubuntu or a bug in kprtx 0.7.4
> (may be alredy fixed ?)

It should work. We do have some patches in Ubuntu to make it work better,
see https://bugs.launchpad.net/ubuntu/+source/multipath-tools/+bug/1747044.

You want to run kpartx with -v to see what's going on there and/or
report a bug at https://bugs.launchpad.net/ubuntu/+source/multipath-tools

-- 
debian developer - deb.li/jak | jak-linux.org - free software dev
ubuntu core developer                              i speak de, en
