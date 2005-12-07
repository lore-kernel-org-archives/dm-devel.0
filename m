From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [multipathd] correct oom_adj value
Date: Wed, 07 Dec 2005 23:29:12 +0100
Message-ID: <1133994552.5650.50.camel@zezette>
References: <4396F875.1050907@suse.de>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4396F875.1050907@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On mer, 2005-12-07 at 15:57 +0100, Hannes Reinecke wrote:
> Hi Christophe,
> 
> any recent kernel will only accept values > -17 for oom_adj.
> So writing '-17' into oom_adj will only lead to an error, not to the
> desired behaviour.
> 
Applied, thanks.
