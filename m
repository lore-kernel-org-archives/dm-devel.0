From: Zdenek Kabelac <zkabelac@redhat.com>
Subject: Re: multipath-0.5.0 still provides broken udev rules
Date: Mon, 25 Apr 2016 14:32:58 +0200
Message-ID: <571E0E7A.4050703@redhat.com>
References: <CAE+k_g+Eh3H1EAiJ0jm7P-efGbOOwpWRtYmvXyR9qhhHtefV7g@mail.gmail.com>
	<571DF852.6030604@redhat.com>
	<CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAE+k_gKQcx+QR9bfEp1Wy8BawD14L2G5O0Yw-d0=CffBHqYbrA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Peter Volkov <peter.volkov@gmail.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 25.4.2016 14:10, Peter Volkov wrote:
> On Mon, Apr 25, 2016 at 1:58 PM, Zdenek Kabelac <zkabelac@redhat.com
> <mailto:zkabelac@redhat.com>> wrote:
>
>     On 25.4.2016 12:52, Peter Volkov wrote:
>
>         There is a problem: udev does not create partitions for multipath
>         devices in
>         case I use kpartx.rules provided with multipath sources. I found that udev
>         always go to kpartx_end after following line of rules:
>         ENV{DM_TABLE_STATE}!="LIVE", GOTO="kpartx_end"
>
>
>     Just curious - what would you want to do with inactive table???
>
>
> Actually don't understand what's this table and what's wrong with that. There
> is no traces of DM_TABLE_STATE variable in lvm2 sources. Yet there is such
> variable in udev rules file that comes with multipath sources:
> http://git.opensvc.com/gitweb.cgi?p=multipath-tools/.git;a=blob;f=kpartx/kpartx.rules;h=022361f907e873ac16fc75459b88af34b27576e5;hb=HEAD


So you would need to figure out which rules would have set  DM_TABLE_STATE 
before ?  (I assume such have never existed...)

In Fedora/RHEL  these  kpartx.rules are not packaged as they are likely some 
'ancient' rules - IMHO  most of that file is useless on today's distros.
(Unsure about dm-wwn logic???)

So it's rather question for upstream kpartx maintainer why these rules
are not maintained in any way.

Vars like DM_TABLE_STATE are simply not created by dm rules.

kpartx rules comes from year 2007, while dm rules started to be maintained in 
2009 - that may explain few things as well...

> That's Gentoo. But I think any distro that uses whatever upstream prepares
> have this problem.
>
>     Have you opened any bugzilla anywhere ?
>
>
> Not yet. I'd like to understand what needs to be done first.
>

Likely Gentoo should not install obsoleted udev rules file.

Regards

Zdenek

PS: I could be wrong here - since I've nothing in common with multipath,
so in such case - feel free to correct me....
