From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 0/1] Missing RDAC patch
Date: Fri, 14 Apr 2017 01:52:39 +0200
Message-ID: <d101f52a-c78f-1f86-017b-6d3d0f4ccae4@gmail.com>
References: <CABr-GncgE=O+XAFENX8fkg9ofa2crk27UuKVTTHKhfwku4k_ow@mail.gmail.com>
	<20170413153948.26557-1-mwilck@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170413153948.26557-1-mwilck@suse.com>
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
To: Martin Wilck <mwilck@suse.com>
Cc: "Schremmer, Steven" <Steve.Schremmer@netapp.com>, dm-devel@redhat.com, Vijay Chauhan <vijay.chauhan@netapp.com>, "Stewart,
	Sean" <Sean.Stewart@netapp.com>
List-Id: dm-devel.ids

On 04/13/2017 05:39 PM, Martin Wilck wrote:

> I'm sending this on Hannes' behalf now. Sorry we didn't make it for 0.7.0.

You're lucky, 0.7.0 release wasn't tagged yet.

> Hannes Reinecke (1):
>   libmultipath/propsel: Do not select sysfs prioritizer for RDAC arrays
>
>  libmultipath/discovery.c |  2 +-
>  libmultipath/discovery.h |  1 +
>  libmultipath/propsel.c   | 24 ++++++++++++++++++++++--
>  3 files changed, 24 insertions(+), 3 deletions(-)
