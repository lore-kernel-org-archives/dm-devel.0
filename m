From: Markus <dieoma@gmail.com>
Subject: Re: setup Pathpriority manually
Date: Sat, 23 Jun 2007 11:25:03 +0200
Message-ID: <e9cb6ff40706230225y55e38350s9ef92c30f766883e@mail.gmail.com>
References: <e9cb6ff40706211113p3ea83a3di35658b19c5145b4d@mail.gmail.com>
	<1182452267.5301.123.camel@linuxchandra> <467B701A.3000108@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <467B701A.3000108@suse.de>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hannes,

thanks for putting some light on that - i would highly appriciate if
you could give me a small sample script so that i could adopt? Also i
think it would be good to supply those samples along with
multipath-tool package for reference...
Your question regarding the array: I=B4am talking about an FalconStor
IPStor Virtualisation engine (like IBM SVC or Datacore) which sits
between the Client and it=B4s Storage.

Thanks in advance
Markus

2007/6/22, Hannes Reinecke <hare@suse.de>:
> Chandra Seetharaman wrote:
> > On Thu, 2007-06-21 at 20:13 +0200, Markus wrote:
> >> Hi,
> >>
> >> i do have an active-passive Storage where the LUN could be used by
> >> both Controllers but one is bloody slow. I tried all
> >> /sbin/mpath_prio_* ways do determin which is the "active" one but no=
ne
> >> of them worked. Is there a way to set this manually? Is there a
> >> different way to determin which is which rather than using the
> >> existing Commands?
> >
> > If your device is not one of the supported devices, you can ask the
> > vendor about how to determine the active and passive paths.
> >
> > mpath_prio_tpc is a good example of how the active/passive device
> > information is used to determine the path priority.
> >
> Yes, but this assumes that documentation about the device is available.
> That is not always the case (no NDA, uncooperative Vendors, or Vendor
> gone out of Business etc.)
>
> There is actually an easier way to do this: As all the mpath_* callouts
> are in fact standalone programs, so you can easily supply your own call=
out.
> Just write a small shell script which takes the device name as input.
> The priority is just the return value of that program; the path with
> the highest priority will take precedence over all the others.
> Paths with identical priorities will be grouped into a path group if
> the policy is set to 'group_by_prio' (which I would recommend if a
> priority callout is specified).
> The task of figuring out the physical location of a controller by
> specifiying the device node is left to the reader.
> But relying on udev here might be dangerous as multipathd might run
> in parallel to udev.
>
> HTH.
>
> Just out of curiousity: Which machine is that?
> Would be an idea to put that into the hardware table, if only with
> a large fat
> "Don't use that array unless you know what you're doing"
> kinda-thing warning.
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                   zSeries & Storage
> hare@suse.de                          +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
>
