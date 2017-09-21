From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v3 0/6] multipath: alternative
	reservation_key method
Date: Thu, 21 Sep 2017 13:24:51 +0200
Message-ID: <5f73ebac-80e7-8ee5-9095-92208beb477d@gmail.com>
References: <1505936117-19547-1-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1505936117-19547-1-git-send-email-bmarzins@redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>, device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 09/20/2017 09:35 PM, Benjamin Marzinski wrote:

FYI, v1 was included in 0.7.3

> The scsi persistent reservation API doesn't force devices to implement any
> method to display the mapping from a reservation key to an I_T Nexus (the
> READ_FULL_STATUS action is an optional later addition, and a number of devices
> don't support it). To allow multipathd to determine the correct reservation key
> for a device without support from the device itself, it uses the
> reservation_key configuration option. Unfortunately, using this option forces
> the multipath configuration to be updated whenever a new scsi registration key
> is used.  This isn't acceptable to some users, who want a static configuration
> file. I've had multiple requests to allow persistent reservations without
> needing to set the reservation_key paramter beforehand.
> 
> This patch set provides an alternative method of setting the reservation_key
> for the multipath device. The reservation_key configuration option now also
> accepts the keyword "file". If this is used, multpath will look in the new
> prkeys file (by default "/etc/multipath/prkeys") for a line with the device
> wwid and it's associated reservation_key. The patches allow users to manually
> set reservation_key to multipath device mappings by using the multipathd
> client commands, but mpathpersist will automatically detect when devices are
> configured to use the prkeys file, and will set and clear the reservation
> keys automatically.
> 
> Changes in v3:
>  - Add documentation for new options and commands (Xose Vazquez Perez)
>    [PATCH v3 6/6] multipath: add man page info for my prkey changes
>  - Fix error in checking if multipathd needs to set the prkey for a device
>    in mpath_persistent_reserve_out
>    [PATCH v3 5/6] mpathpersist: add support for prkeys file
> 
> Changes in v2:
>  - use struct be64 instead of uint64_t to hold the reservation_key
>    (Martin Wilck)
> 
> Benjamin Marzinski (6):
>   libmultipath: pull functions into util.c
>   libmultipath: change reservation_key to a be64
>   libmpathpersist: fix update_prflag code
>   multipath: add alternate reservation_key method
>   mpathpersist: add support for prkeys file
>   multipath: add man page info for my prkey changes
> 
>  libmpathpersist/mpath_persist.c  |  79 ++++++++++---------
>  libmpathpersist/mpath_updatepr.c |  43 ++++++----
>  libmpathpersist/mpathpr.h        |   3 +-
>  libmultipath/Makefile            |   2 +-
>  libmultipath/byteorder.h         |  44 +++++++++++
>  libmultipath/checkers/rbd.c      |  16 +---
>  libmultipath/config.c            |   9 ++-
>  libmultipath/config.h            |   9 ++-
>  libmultipath/defaults.h          |   1 +
>  libmultipath/dict.c              | 105 +++++++++++++------------
>  libmultipath/dict.h              |   4 +-
>  libmultipath/prkey.c             | 166 +++++++++++++++++++++++++++++++++++++++
>  libmultipath/prkey.h             |  19 +++++
>  libmultipath/propsel.c           |  35 +++++++--
>  libmultipath/structs.h           |  12 ++-
>  libmultipath/util.c              |  33 ++++++++
>  libmultipath/util.h              |   4 +
>  multipath/multipath.conf.5       |  17 ++++
>  multipathd/cli.c                 |   8 ++
>  multipathd/cli.h                 |   8 ++
>  multipathd/cli_handlers.c        |  82 +++++++++++++++++++
>  multipathd/cli_handlers.h        |   3 +
>  multipathd/main.c                |  28 +++----
>  multipathd/multipathd.8          |  16 ++++
>  24 files changed, 590 insertions(+), 156 deletions(-)
>  create mode 100644 libmultipath/byteorder.h
>  create mode 100644 libmultipath/prkey.c
>  create mode 100644 libmultipath/prkey.h
> 
