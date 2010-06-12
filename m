From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: 2 TB wraparound on 32 bit host
Date: Sat, 12 Jun 2010 13:58:46 -0400
Message-ID: <4C13CAD6.70902@cfl.rr.com>
References: <4C12A32C.3000501@cfl.rr.com>	
	<1276290990.2862.161.camel@mulgrave.site>
	<4C13AB90.1070802@cfl.rr.com>	
	<1276358598.4399.3.camel@mulgrave.site>
	<1276358949.4399.8.camel@mulgrave.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1276358949.4399.8.camel@mulgrave.site>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 06/12/2010 12:09 PM, James Bottomley wrote:
> Actually, looking at the above, this is conflicting information.  On 64
> bit systems (like amd64) there's no need to set CONFIG_LBDAF because
> sector_t is an unsigned long, which is 64 bits.  It's only on 32 bit
> configurations it gets set.  Initially you said you were using a PAE
> i686 configuration, which would need this setting.  An amd64 one
> wouldn't.
>
> Which kernel are you actually seeing the problem on, and what is
> CONFIG_LBDAF set to on that kernel?

I am seeing the wraparound on two systems, one running the vanilla i386 
Ubuntu Karmic kernel, and one running amd64 Lucid.  I checked the config 
file on the amd64 system I am on now and the symbol CONFIG_LBDAF is not 
there.  I just checked the i386 config and it is set there.  It seems 
then, that this is not the cause of the problem after all.
