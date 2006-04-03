From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Subject: Re: how to trace the device mapper?
Date: Mon, 03 Apr 2006 16:46:28 -0400
Message-ID: <443189A4.1090903@hp.com>
References: <44163012.8020007@zabbo.net>	<20060314135349.GP25317@agk.surrey.redhat.com>
	<002d01c653ca$99f50a30$27c2608c@ITRI.DS>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <002d01c653ca$99f50a30$27c2608c@ITRI.DS>
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

Jui-Pin Yang wrote:

>Hi,
>I would like to trace the device mapper, and any good suggestion to do the
>job
>is welcome such as how to start and so on.
>Thanks
>  
>
If you are looking for interactions with the underlying block I/O layer 
interfaces, you could look into blktrace.

Alan D. Brunelle
HP

>Best Regards
>
>Jui-Pin Yang
>=====================================
>Network & Communication Technology Center
>Computer & Communications Research Laboratory
>Industrial Technology Research Institute
>
>P300 CCL/ITRI
>No.31, Gongye 2nd Rd., Annan District
>Tainan City 709, Taiwan (R.O.C.)
>Tel: 886-6-3847103
>Fax: 886-6-3847182
>E-mail: jpyang@itri.org.tw
>=====================================
>
>--
>dm-devel mailing list
>dm-devel@redhat.com
>https://www.redhat.com/mailman/listinfo/dm-devel
>  
>
