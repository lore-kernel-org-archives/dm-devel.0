From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: multipath can't be run with -S, so don't try
Date: Tue, 03 May 2005 23:31:24 +0200
Message-ID: <1115155884.2277.20.camel@zezette>
References: <20050503211703.GD5323@phlogiston.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050503211703.GD5323@phlogiston.msp.redhat.com>
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

Applied, thanks.

It will appear as commit f849af142710ddfab9d29533be30bbf23dcd5a55 in the
git korg repository, when updated.

Shall I understand you approve the design evolution ?

On mar, 2005-05-03 at 16:17 -0500, Benjamin Marzinski wrote:
> This is a patch clean up the references to -S in multipath, multipathd, and
> the conf files.
> 

-- 
christophe varoqui <christophe.varoqui@free.fr>
