From: =?ISO-8859-1?Q?Roger_H=E5kansson?= <hson@ludd.luth.se>
Subject: Re: Problems with multipathing
Date: Tue, 11 Apr 2006 23:04:38 +0200
Message-ID: <443C19E6.8000607@ludd.luth.se>
References: <443BF12E.50900@ludd.luth.se> <443BF87A.10804@free.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <443BF87A.10804@free.fr>
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
>
> Can you reproduce with upstream version ?
> 

With upstream I guess you mean 0.4.7 or "CVS-HEAD".

Haven't tried that, but just looking at the requirements tells me I'll
have a lot to do in order to even just to prepare to test it.

>  Dependencies :
>  Linux kernel
>
>      * 2.6.10-rc*-udm2 or later
>      * 2.6.11-mm* or later
>      * 2.6.12-rc1 or later
>  udev 050+

CentOS 4.3 have 2.6.9-34 and udev-039-10, and even though some stuff are
backported I guess I have to update both and I can only imagine the
amount of work that will render me, but I'll try to do it if I can find
the time...

	
