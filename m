From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: pre8
Date: Wed, 6 Apr 2005 08:32:40 +0200
Message-ID: <20050406063240.GC12408@averon.dyndns.org>
References: <20050405213223.GJ9049@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20050405213223.GJ9049@agk.surrey.redhat.com>
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

On Tue, Apr 05, 2005 at 10:32:23PM +0100, Alasdair G Kergon wrote:
> I appear to have almost succeeded in squeezing 0.4.4-pre8 into 
> RHEL4 U1, but I doubt I'll be allowed any more updates now except 
> for severe bugs.
> 
Just to let you you know what I think is still needed before 0.4.4 :

o memory allocation error paths audit (mostly done in pre9)
o don't loose events in multipathd
o /dev/shm/cache has the same security problems you spotted in /tmp

I guess this last item will help justify your upgrading to 0.4.4

Regards,
cvaroqui
