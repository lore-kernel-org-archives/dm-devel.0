From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: dm-multipath: multipathd blacklisting
Date: Sat, 18 Feb 2006 00:56:39 +0100
Message-ID: <1140220599.21077.20.camel@zezette>
References: <20060214230114.GB14779@ether.msp.redhat.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20060214230114.GB14779@ether.msp.redhat.com>
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

On mar, 2006-02-14 at 17:01 -0600, Benjamin Marzinski wrote:
> multipathd doesn't correctly blacklist devices by wwid, because the blacklist
> check happens before the device information is known. This patch fixes that.
> 
Applied, thanks.
