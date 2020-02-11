From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH v2 10/17] libmultipath: add code to get
 vendor specific vpd data
Date: Tue, 11 Feb 2020 08:39:21 +0000
Message-ID: <66dd0eeb3245d7d350bf98e4511823918d150e5d.camel@suse.com>
References: <1580929100-32572-1-git-send-email-bmarzins@redhat.com>
	<1580929100-32572-11-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1580929100-32572-11-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <8CF1518E5100A2439158042A20323D37@namprd18.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "christophe.varoqui@opensvc.com" <christophe.varoqui@opensvc.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Wed, 2020-02-05 at 12:58 -0600, Benjamin Marzinski wrote:
> This adds the wildcard 'g' for multipath and path formatted printing,
> which returns extra data from a device's vendor specific vpd
> page.  The
> specific vendor vpd page to use, and the vendor/product id to decode
> it
> can be set in the hwentry with vpd_vendor_pg and vpd_vendor_id. It
> can
> be configured in the devices section of multipath.conf with the
> vpd_vendor parameter. Currently, the only devices that use this are
> HPE
> 3PAR arrays, to return the Volume Name.
> 
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> ---
>  libmultipath/config.c      |  2 ++
>  libmultipath/config.h      |  1 +
>  libmultipath/dict.c        | 38 ++++++++++++++++++++++++++++++++++++
>  libmultipath/discovery.c   | 40
> +++++++++++++++++++++++++++++++++++++-
>  libmultipath/hwtable.c     |  1 +
>  libmultipath/print.c       | 25 ++++++++++++++++++++++++
>  libmultipath/propsel.c     | 18 +++++++++++++++++
>  libmultipath/propsel.h     |  1 +
>  libmultipath/structs.h     | 15 ++++++++++++++
>  multipath/multipath.conf.5 |  8 ++++++++
>  10 files changed, 148 insertions(+), 1 deletion(-)

Acked-by: Martin Wilck <mwilck@suse.com>

(wishing that the memory usage can be decreased in a follow-up patch).
