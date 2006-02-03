From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: Multipath unable to see drives
Date: Fri, 03 Feb 2006 21:10:29 +0100
Message-ID: <1138997430.17909.0.camel@zezette>
References: <43E36E94.1040902@morris.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <43E36E94.1040902@morris.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On ven, 2006-02-03 at 09:54 -0500, David James wrote:
> /sbin/scsi_id -g -u -s /block/sda

Try to figure why this callout fails.
You can do that independently from the tools.

Regards,
cvaroqui
