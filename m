From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: add IBM/FlashSystem to
 hwtable
Date: Wed, 12 Oct 2016 16:44:02 +0200
Message-ID: <43dd1137-eb28-ebf6-8a01-ad4a21e986ed@gmail.com>
References: <20161007131522.3442-1-xose.vazquez@gmail.com>
	<7e9c1d8c-31df-5064-569a-01d3861925a9@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <7e9c1d8c-31df-5064-569a-01d3861925a9@linux.vnet.ibm.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Steffen Maier <maier@linux.vnet.ibm.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/07/2016 04:24 PM, Steffen Maier wrote:

> You'll notice that we from Linux on s390x have a bit different recommendations
> for some of the values (no_path_retry actually depends on whether you have a
> cluster software/filesystem that can cope with EIO on last-path-loss. Currently,
> I see the default without that, i.e. non-clustered from which we would like to hide any path issues).

This has to be modified manually.

> Is there some way to have "dependent" settings?

No. multipath.conf is mainly static.
Only two options are dynamically reconfigured, ALUA-prio and the hardware handler
with "detect_prio" and "retain_attached_hw_handler".
