From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: EMC Envista hwtable entry broken?
Date: Wed, 03 Feb 2010 15:34:45 +0100
Message-ID: <1265207685.26432.6.camel@zezette>
References: <20100203132422.GA10205@ochil.suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100203132422.GA10205@ochil.suse.de>
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

On mer., 2010-02-03 at 14:24 +0100, Hannes Reinecke wrote:
> Hi Christophe,
> 
> it seem that the entry for EMC Envista is broken; it is referring to an unknown field 'getprio'.
> Maybe we should fix that up and use 'prio_name = DEFAULT_PRIO' instead?
> 
Fixed. Thanks for pointing out I merge with brain off :)

-- 
cvaroqui,
http://www.opensvc.com
