From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: two minor multipath tools fixes
Date: Fri, 11 Nov 2005 22:48:20 +0100
Message-ID: <1131745701.7463.83.camel@zezette>
References: <20051111000832.GA9399@phlogiston.msp.redhat.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051111000832.GA9399@phlogiston.msp.redhat.com>
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

On jeu, 2005-11-10 at 18:08 -0600, Benjamin Marzinski wrote:
> There was a spot where multipathd's reply length forgot to count the NULL,
> and I noticed that the way domap go rewritten, the dry-run option doesn't
> print out the maps.
> 
> This patch fixes both.
> 
Applied, thanks.

Regards,
cvaroqui
