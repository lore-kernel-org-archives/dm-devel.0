From: James Smart <James.Smart@Emulex.Com>
Subject: Re: Problems with multipathing
Date: Tue, 18 Apr 2006 15:24:34 -0400
Message-ID: <44453CF2.9080507@emulex.com>
References: <443BF12E.50900@ludd.luth.se>	<443BF87A.10804@free.fr>	<443C19E6.8000607@ludd.luth.se>	<443E870E.1070902@ludd.luth.se>	<443EB907.1070600@free.fr>	<4442E2ED.7020405@ludd.luth.se>
	<4443635F.5000401@free.fr>
Reply-To: James.Smart@Emulex.Com,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4443635F.5000401@free.fr>
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


Christophe Varoqui wrote:
> Do failover device nodes get reassigned during the rescan ?
> Like, for example, a configured path sda gets removed and a new path sdb 
> appears ?
> If so, the FC transport class is in charge of the timeout triggering the 
> dead devices removal.
> A hardware handler wouldn't help here.

On the kernel rev he's talking about, 2.6.9-34, the FC transport class
doesn't fully exist, so there's no automatic device removal.

-- james
