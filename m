From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH] Update path_offline() to return device status
Date: Wed, 03 Feb 2010 15:33:47 +0100
Message-ID: <1265207627.26432.5.camel@zezette>
References: <20100203132222.4BF1329CC3@ochil.suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100203132222.4BF1329CC3@ochil.suse.de>
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

> This patch updates the path_offline() function to return the
> actual device state. Path checkers will only be run if the
> state is PATH_UP. A 'blocked' device state will be translated
> into PATH_PENDING, causing the checkerloop to skip this device
> and recheck as soon as possible.
> 
Nice addition indeed,
applied and pushed.

-- 
cvaroqui,
http://www.opensvc.com
