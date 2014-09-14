From: Nir Soffer <nsoffer@redhat.com>
Subject: Re: [PATCH 0/6] Misc multipath patches
Date: Sun, 14 Sep 2014 09:17:31 -0400 (EDT)
Message-ID: <1673595407.37577474.1410700651588.JavaMail.zimbra@redhat.com>
References: <1410543892-29826-1-git-send-email-bmarzins@redhat.com>
	<CABr-GneJNtvp+CehV2LzaNcjm2gXF3AdLUqvDRPMfPSrNzpkTg@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CABr-GneJNtvp+CehV2LzaNcjm2gXF3AdLUqvDRPMfPSrNzpkTg@mail.gmail.com>
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
Cc: Federico Simoncelli <fsimonce@redhat.com>
List-Id: dm-devel.ids

----- Original Message -----
> From: "Christophe Varoqui" <christophe.varoqui@opensvc.com>
> To: "Benjamin Marzinski" <bmarzins@redhat.com>
> Cc: "device-mapper development" <dm-devel@redhat.com>
> Sent: Saturday, September 13, 2014 9:57:00 AM
> Subject: Re: [dm-devel] [PATCH 0/6] Misc multipath patches
> 
> Hi,
> 
> this patchset is now all merged upstream, except the " all_devs device
> option" part.
> I'd like other's comments on this.
> I personnality think the goal is fine, 

The goal is critical for us (ovirt/rhev). We need a way to configure any
any device on multiple (100's) hosts to use no_path_retry fail.
We have several bugs caused by unwanted queuing in multipath.

> but the configuration plug is not so
> intuitive.

I agree that the suggested patch is not intuitive.

all_devs overrides only devices with built-in configuration. Other 
devices will use the defaults.

So practically this is not enough:

    devices {
        device {
            all_devs yes
            no_path_retry fail
        }
    }

You must do this:

    defaults {
        no_path_retry fail         # keep in sync with all_devs bellow
    }

    devices {
        device {
            all_devs yes
            no_path_retry fail     # keep in sync with defaults above
        }
    }

It would be nice if we could add a device that match any device,
and use it to override *some* settings:

    devices {
        device {
            vendor ".*"
            no_path_retry fail
        }
    }

I tried this, and it seem to remove settings not defined in this device
for example, hwhandler. Looks like multipath does not use the built-in
configuration for any device when such device exists.

Making this work will probably be backward incompatible since
people may assume the old behavior.

Another option that may be useful is:

    multipaths {
        multiapth {
            wwid ".*"
            no_path_retry fail
        }
    }

This does not work because multipath sections are matched using strcmp.
Changing this may be also not backward compatible.

> We already have a top-level "default" section, would defining a top-level
> "override" section be more intuitive ?

I think that would be much better from the user point of view, and
should be simpler to implement.

What I would expect from this configuration is to be able to set:

    overrides {
        no_path_retry fail
    }

And have it override all devices, both those with built-in configuration
and those that have no configuration.

Not sure it this should override also devices with device section
in multipath configuration, since this will prevent an admin to 
configure specific device.

Nir
