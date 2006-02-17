From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: dm-multipath: failback problem.
Date: Sat, 18 Feb 2006 00:59:13 +0100
Message-ID: <1140220753.21077.22.camel@zezette>
References: <20060216164808.GA15044@ether.msp.redhat.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060216164808.GA15044@ether.msp.redhat.com>
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

On jeu, 2006-02-16 at 10:48 -0600, Benjamin Marzinski wrote:
> If the failback period is set to more that four times the polling interval,
> paths will never fail back. This is because the failback_tick keeps getting
> reet. The attached patch fixes this.
> --
Correct. Applied with thanks.

Regards,
cvaroqui
