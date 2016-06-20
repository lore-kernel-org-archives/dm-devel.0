From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH 08/10] multipath-tools: remove
 USER_FRIENDLY_NAMES_OFF
Date: Mon, 20 Jun 2016 11:42:21 +0100
Message-ID: <20160620104221.GA31739@hex>
References: <1466175169-16684-1-git-send-email-xose.vazquez@gmail.com>
	<1466175169-16684-8-git-send-email-xose.vazquez@gmail.com>
	<CABr-GneYSo9zHqsn45wsigTX+sMpu8SgEquBEU_4Qoka47XgZg@mail.gmail.com>
	<5767962E.7090800@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <5767962E.7090800@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, Jun 20, 2016 at 09:07:26AM +0200, Hannes Reinecke wrote:
> On 06/20/2016 08:58 AM, Christophe Varoqui wrote:
> >     @@ -1133,7 +1132,6 @@ static struct hwentry default_hw[] = {
> >                     .pgfailback    = -FAILBACK_IMMEDIATE,
> >                     .checker_name  = TUR,
> >                     .fast_io_fail  = 10,
> >     -               .user_friendly_names = USER_FRIENDLY_NAMES_OFF,
> >                     .prio_name     = DEFAULT_PRIO,
> >                     .no_path_retry = 0,
> 
> No, indeed, that's fine.

Agreed: multipath names are mysterious enough for many users without
compiled-in defaults changing things behind their backs.

Regards,
Bryn.
 
