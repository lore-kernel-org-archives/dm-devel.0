From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: multipathd.init
Date: Fri, 01 Apr 2005 23:09:04 +0200
Message-ID: <1112389744.8118.26.camel@zezette>
References: <20050401204048.GI14307@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050401204048.GI14307@agk.surrey.redhat.com>
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

On ven, 2005-04-01 at 21:40 +0100, Alasdair G Kergon wrote:
> Attached is a cleaned-up version of multipathd init script - at least 
> for Red Hat based systems.
> 
> While it uses the standard daemon-handling functions, it's still only 
> suitable for a few situations though.
> 
> If you have / on dm-multipath, the daemon has to be started from
> the initrd - so you don't want it stopping/starting from init.d,
> but you might want to HUP it.
> 
Not agreed.

The daemon is only needed for the multipathed FS to survive PG failover
-> PG failback cycles.

Hence, the vulnerability window is between "/ mounted in intrd" and
"multipathd started in rc?.d/".

Do we really want to do complicated things to close that window ? I
would guess not.

I insist : we do survive simple PG failover during that risky window,
with multipathd running. The failing scenario probability is so thin ...

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
