From: Joe Thornber <thornber@redhat.com>
Subject: Re: dm-cache fs corruption
Date: Thu, 28 Nov 2013 17:28:13 +0000
Message-ID: <20131128172813.GA24861@debian>
References: <CALwk7=xhJBoxyvM4yw0DwFGQoOmhAxp1p9C0oid_Wh4tzxSf5w@mail.gmail.com>
	<20131113144112.GF13882@debian>
	<CALwk7=zWxL1QD3_pujA-QpWOCLLbJKT31p5HqTrzJwYPETh26g@mail.gmail.com>
	<CALwk7=xi2NBOE+bGcoygtsqFYzSE8a7DsC7p7MCRd06QU6jihQ@mail.gmail.com>
	<33A0129EBFD46748804DE81B354CA1B21C031F48@SACEXCMBX06-PRD.hq.netapp.com>
	<20131114143832.GC17651@debian>
	<CALwk7=xBTqtOQqXx6WnGyLAAXz4+wrQ9W3MOjs66mWBRhmqxBw@mail.gmail.com>
	<CALwk7=xGynqqH2CN8Eop7qioSR9FGVt7AmGRLkwWXC87KVO8WA@mail.gmail.com>
	<CALwk7=wgChKoSqnj_CJwRfnRRwrfNnjPkr-zVGKunOTSjWz2Pw@mail.gmail.com>
	<CALwk7=x72BKSFgja2zy38qfusEwTSebcaFBpuAkOaed0F-zJcQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALwk7=x72BKSFgja2zy38qfusEwTSebcaFBpuAkOaed0F-zJcQ@mail.gmail.com>
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

On Thu, Nov 28, 2013 at 06:50:39PM +0200, Vladimir Smolensky wrote:
> Hello, I would like to test the latest dm-cache available to see if the
> problem I was having still exists. Where can I get this code?

My latest stable code lives in the 'thin-dev' branch of my github tree:

https://github.com/jthornber/linux-2.6/tree/thin-dev

This has the latest versions of both the thin-provisioning and cache
targets, and will shortly have the era target too.


- Joe
