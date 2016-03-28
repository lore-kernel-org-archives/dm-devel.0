From: Eric Wheeler <dm-devel@lists.ewheeler.net>
Subject: Re: [PATCH] thin_dump: added --device-id, --skip-mappings,
 and new output --format's
Date: Mon, 28 Mar 2016 02:51:37 +0000 (UTC)
Message-ID: <alpine.LRH.2.11.1603280249540.13440@mail.ewheeler.net>
References: <alpine.LRH.2.11.1603150104370.19675@mail.ewheeler.net>
	<20160324153509.GA3101@rh-vpn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160324153509.GA3101@rh-vpn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Joe Thornber <thornber@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Thu, 24 Mar 2016, Joe Thornber wrote:
> On Tue, Mar 15, 2016 at 01:45:15AM +0000, Eric Wheeler wrote:
> > Hi Joe,
> > 
> > Please review the patch below when you have a moment.  I am interested in 
> > your feedback, and also interested in having this functionality merged 
> > upstream.  This was written against thin-provisioning-tools.git tag 
> > v0.5.6.
> 
> These changes are now on the v0.7-devel branch:
> 
> i) --dev-id to filter thin_dump output on device id, multiple selections allowed.
> ii) --skip-mappings
> iii) thin_dump now takes a format called 'custom' that let's you use a plugin emitter of your own.
> 
>      eg, 
> 
>      thin_dump --format custom=contrib/ewheeler_emitter.so /dev/sda
> 
> 
> The contrib/ directory is for third party contributions.  Use 'make
> contrib' to build it.  I've put your emitter and tmakatos' emitter in
> there already.
> 
> I hope that covers everything you need.

I think that will work nicely. Thank you!  

-Eric

> 
> - Joe
> 
