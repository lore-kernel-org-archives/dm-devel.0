From: Bernd Zeimetz <bernd@bzed.de>
Subject: Re: Clariion CX600 automatic failback support
Date: Thu, 10 Nov 2005 20:24:55 +0100
Message-ID: <200511102024.55481.bernd@bzed.de>
References: <C2EEB4E538D3DC48BF57F391F422779321ADAC@SRMANNING.eng.emc.com>
	<200511050103.58170.bernd@bzed.de>
	<1131193587.7463.16.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1131193587.7463.16.camel@zezette>
Content-Disposition: inline
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

Hi,

> Want to write a regression test ?

Doubt that's really neccessary - at least not for us (which means I'll have to 
work on the other waiting projects first before doing anything else here). 
Due to the lack of the company where we've bought the machine (unfortunately 
not directly from EMC) in supporting us with their own 
closed-source-multipath-modules for an actual kernel.org kernel it took me 
more time than planned to get the CX running stable again. Many thanks again 
to Christophe, Edward and Kevin for the support & patches!

Within the next week I'll update your wiki with a completion of the 
DebianInstall page, which will include a link to an updated multipath-tools 
package (latest git) for Debian Sarge.

A few minutes ago I've added the CX to 
http://christophe.varoqui.free.fr/wiki/wakka.php?wiki=TestedEnvironments - I 
hope it'll be useful. Please let me know if I've forgotten anything.

Thanks again,

Bernd
