From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] libmultipath: fix flush_on_last_del config
 handlers
Date: Sat, 22 Dec 2012 09:43:27 +0100
Message-ID: <1356165807.15155.19.camel@lapoo.opensvc.com>
References: <50D4B462.4020708@oracle.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <50D4B462.4020708@oracle.com>
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

On ven., 2012-12-21 at 11:11 -0800, Guangyu Sun wrote:
> Now flush_on_last_del cannot be set to FLUSH_DISABLED if its default
> value is FLUSH_ENABLED. This patch fixes the issue.

Good catch. Applied.

Thanks,
Christophe Varoqui,
http://www.opensvc.com
