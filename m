From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [RFC] training mpath to discern between SCSI errors
Date: Mon, 30 Aug 2010 14:51:14 +0200
Message-ID: <1283172674.23482.3.camel@localhost>
References: <20100825155918.GB8509@redhat.com> <4C7B984E.4070802@suse.de>
	<4C7B9F14.9080900@mvista.com>  <4C7BA670.2060303@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4C7BA670.2060303@suse.de>
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
List-Id: dm-devel.ids


> So we would be ending with:
> 
> ENOLINK: transport failure
> EIO: retryable remote failure
> EREMOTEIO: non-retryable remote failure
> 
would scsi reservation conflict errors raise EREMOTEIO in this case ?

regards,
-- 
Christophe Varoqui <christophe.varoqui@opensvc.com>
OpenSVC
