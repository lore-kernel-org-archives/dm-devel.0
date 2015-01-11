From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Re: [PATCH 3/6] libmultipath: add overrides section to
 multipath.conf
Date: Mon, 12 Jan 2015 00:15:25 +0100
Message-ID: <20150112001525.0000473f@localhost>
References: <1416377859-15073-1-git-send-email-bmarzins@redhat.com>
	<1416377859-15073-4-git-send-email-bmarzins@redhat.com>
	<CABr-GndVm5ct_E7UoF86no5b36k8MpLU4KD5pYtO=h1NiT4LGQ@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GndVm5ct_E7UoF86no5b36k8MpLU4KD5pYtO=h1NiT4LGQ@mail.gmail.com>
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
Cc: Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

Christophe Varoqui wrote:
> I have no strong opinion on this one : I feel like the complexity of the
> parameter inheritance system is already quite complicated ... but this
> addition of a new layer would likely and safely be ignored by users who
> don't need it. Those who need it are surely ready to pay the price.
> 
> Does someone have objection to my applying this patch ?
> 
> Best regards,
> Christophe
> 
> 
> 
> On Wed, Nov 19, 2014 at 7:17 AM, Benjamin Marzinski <bmarzins@redhat.com>
> wrote:
> 
> > Sometimes users want to be able to set a configuration value for all their
> > devices (for instance, they may want all devices to set no_path_retry to
> > fail). The builtin device configurations make this tricky, since users need
> > to change each device configuration individually. To avoid that, this patch
> > adds a new section to multipath.conf, "overrides".  This section has all of
> > the attributes that are in both the devices and defaults section.
> > Attributes set in the overrides section have a higher priority that those
> > in the devices section. With this section added, the multipath
> > configuration order now goes:
> >
> > multipaths > overrides > devices > defaults
> >
> > I also made want_user_friendly_names print out where the configuration came
> > from, and I made made select_hwhandler and select_selector always strdup
> > the string, instead of only on the defaults.  Since multipathd will update
> > the device strings from the kernel anyway, the old way just added
> > complexity without saving any memory.
> >
> > To store the overrides configuration, I used a hwentry structure. We may
> > want to make a new overrides structure, so that we set any of the defaults
> > values in overrides.  That way, users could skip using defaults and just
> > use overrides if they wanted. However, this would take some additional
> > changes to make sure that all the defaults options can undefined, which
> > they can't currently be.
> >

What's the current precedence of the configuration sections? I don't think
the manual pages document this (sufficiently). I guess the precedence is:

multipaths > devices > defaults

But where do the built-in device configurations fit in? It seems those are
somehow merged with the user supplied entries from the configuration file.

Would changing the precedence to

multipaths > devices > defaults > built-in devices

fix the issue at hand?

Sebastian
