From: Martin Wilck <Martin.Wilck@suse.com>
Subject: Re: [PATCH 4/4] libmultipath: fix checker detection for
	nvme devices
Date: Thu, 2 Jul 2020 15:17:31 +0000
Message-ID: <c7c3a9111d9b4d0854ea0e6f6faeefc7437e01fb.camel@suse.com>
References: <1593643176-6206-1-git-send-email-bmarzins@redhat.com>
	<1593643176-6206-5-git-send-email-bmarzins@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1593643176-6206-5-git-send-email-bmarzins@redhat.com>
Content-Language: en-US
Content-ID: <C6504E74C40B7748864AFC103779419A@eurprd04.prod.outlook.com>
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

On Wed, 2020-07-01 at 17:39 -0500, Benjamin Marzinski wrote:
> In order to fix hwhandler autodetection, commit 8794a776 made
> detect_alua() differentiate between failures to detect whether alua
> was
> supported, and successfully detecting that it was not supported.
> However, this causes nvme devices to get the TUR checker assigned to
> them. This is because there is nothing in detect_alua() to make it
> only
> work on scsi devices, and select_checker wasn't updated to handle
> detect_alua() failing without setting pp->tpgs to TPGS_NONE.
> 
> detect_alua() should automatically set pp->tpgs to TPGS_NONE and exit
> on
> non-scsi devices. Also, select_checker() should not assume that a
> devices is ALUA, simply because if failed to detect if alua was
> supported.
> 
> Fixes: 8794a776 "libmultipath: fix ALUA autodetection when paths are
>                  down"
> Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>

Reviewed-by: Martin Wilck <mwilck@suse.com>
