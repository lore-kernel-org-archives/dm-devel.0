From: Luca Berra <bluca@comedia.it>
Subject: Re: Avoid Error Messages in /var/log/messages EMC CX300
Date: Fri, 29 Sep 2006 12:57:35 +0200
Message-ID: <20060929105735.GA23846@percy.comedia.it>
References: <C514D40EFDB5C84083DAEB84A1186A8F266AEB@msc-ex02.msc-ge.mscnet>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <C514D40EFDB5C84083DAEB84A1186A8F266AEB@msc-ex02.msc-ge.mscnet>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

On Wed, Sep 27, 2006 at 12:26:56PM +0200, Herr, Manuel wrote:
>Hi there,
>i get Error Messages in my logfiles when I boot the System and then, approx. every 10 Minutes, or during an hwinfo.
>The Server is connected to an EMC CX 300 through 1 Qlogic HBA.
>The Messages only appear for the failover Device. In my Example for /dev/sdh. 
,,,
>--> Generates this Error in /var/log/messages
>Sep 27 12:17:44 saptf2 kernel: end_request: I/O error, dev sdh, sector 0
>Sep 27 12:17:44 saptf2 kernel: Buffer I/O error on device sdh, logical block 0

find the process that is responsible for querying the device and stop
it,

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
