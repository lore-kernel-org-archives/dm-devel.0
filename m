From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache fs corruption
Date: Thu, 14 Nov 2013 14:38:33 +0000
Message-ID: <20131114143832.GC17651@debian>
References: <CALwk7=z+Xc8Xrcw5jo8DtKwT9KS2gQMumtaHTws0w4+VDs2NwQ@mail.gmail.com>
	<20131113131022.GA13882@debian>
	<CALwk7=xhJBoxyvM4yw0DwFGQoOmhAxp1p9C0oid_Wh4tzxSf5w@mail.gmail.com>
	<20131113144112.GF13882@debian>
	<CALwk7=zWxL1QD3_pujA-QpWOCLLbJKT31p5HqTrzJwYPETh26g@mail.gmail.com>
	<CALwk7=xi2NBOE+bGcoygtsqFYzSE8a7DsC7p7MCRd06QU6jihQ@mail.gmail.com>
	<33A0129EBFD46748804DE81B354CA1B21C031F48@SACEXCMBX06-PRD.hq.netapp.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <33A0129EBFD46748804DE81B354CA1B21C031F48@SACEXCMBX06-PRD.hq.netapp.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, Nov 13, 2013 at 06:39:37PM +0000, Mears, Morgan wrote:
> On Wed, Nov 13, 2013 at 11:29:26AM -0005, Vladimir Smolensky wrote:
> > Hello, 
> > I'm compiling the for-linus branch, it shows 3.12.0-rc5, that's ok right?
> > 
> > Where can I get cache_restore, cache_dump, etc. and info how to use them.
> 
> Hi Vladimir,
> 
> git clone https://github.com/jthornber/thin-provisioning-tools.git
> cd thin-provisioning-tools
> autoreconf
> ./configure --enable-testing
> make
> sudo cp cache_check cache_dump cache_restore cache_repair /usr/sbin
> cache_check --version
> 
> This is mostly distilled from README.md in the repo; there are some
> additional dependencies in there that you might have to address.
> 
> All the tools have a --help option; not sure about other documentation.
> 
> --Morgan

'make install' should work, and I believe there are some man pages.

- Joe
