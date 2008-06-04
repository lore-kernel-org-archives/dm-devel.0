From: Gustavo Riveros <gustavo.riveros@provectis.cl>
Subject: multipathing Sun 6140
Date: Wed, 04 Jun 2008 17:14:57 -0400
Message-ID: <484705D1.6080200@provectis.cl>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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
Cc: julio.pacheco@provectis.cl
List-Id: dm-devel.ids

Hi dm-developers,

I'm having problem with multipathing device-mapper with my linux server, 
but this was resolved by Thread "multipathing flip flopping on Sun 6140" 
very well 
(http://www.redhat.com/archives/dm-devel/2007-August/msg00066.html)

The configuration is the same:

X4600 Server
2 HBA's Emulex
SAN STK6140

but in dmesg i have the following error message:

Buffer I/0 error on device sdf, logical block 0
end_request: I/0 error, dev sdf, sector 0

Did you know the error message?

Thanks,
Gustavo Riveros
