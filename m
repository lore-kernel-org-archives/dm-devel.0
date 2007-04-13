From: "Penguin Lin" <penguin.taiwan@gmail.com>
Subject: device-mapper mirror module (dm-raid)
Date: Fri, 13 Apr 2007 17:49:07 +0800
Message-ID: <f535b83b0704130249q55517c15recc876490524fe63@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1424928889=="
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
List-Id: dm-devel.ids

--===============1424928889==
Content-Type: multipart/alternative;
	boundary="----=_Part_3151_27532351.1176457747801"

------=_Part_3151_27532351.1176457747801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Dear all:

Recently I am keeping tracing the device-mapper codes in kernel-2.6.20.1

There are still some question that confuse me...
and I hope to change something in mirror driver...

---------------------------------------------------------------

1. Is recovery here really necessary ?

Every time when a bio is written to a mirrred target, mirror driver will
queue
this io to the write bio_list whthin the mirror_set, finally a kcopyd will
be
invoke to write this bio to all mirrored device. Is the flow correct?

But... there are nothing doing in  the write callback function
(write_callback).... right ?
So in the current version, we won't have any regions that is needed to be
recovered.

----------------------------------------------------------------

2. Should we put all read action into the read bio_list of the mirror_set ?

In mirror_map.... should we put all read requests into the read bio_list of
the
mirror_set after check the return value from log->type->in_sync(), since
do_read() method does the same thing and it will be invoke when a do_work
is invoke? Or shoulwe d move all read actions including the checking
(in mirror_map) to the do_read() function ?

----------------------------------------------------------------

Thanks for all...
and please forgive my Chinese English..... is too poor....
(hopes some one understand what I am talking about in above...)

regard.

------=_Part_3151_27532351.1176457747801
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Dear all:<br><br>Recently I am keeping tracing the device-mapper codes in kernel-2.6.20.1<br><br>There are still some question that confuse me...<br>and I hope to change something in mirror driver...<br><br>---------------------------------------------------------------
<br><br>1. Is recovery here really necessary ?<br><br>Every time when a bio is written to a mirrred target, mirror driver will queue <br>this io to the write bio_list whthin the mirror_set, finally a kcopyd will be <br>invoke to write this bio to all mirrored device. Is the flow correct?
<br><br>But... there are nothing doing in&nbsp; the write callback function (write_callback).... right ?<br>So in the current version, we won&#39;t have any regions that is needed to be recovered.<br><br>----------------------------------------------------------------
<br><br>2. Should we put all read action into the read bio_list of the mirror_set ?<br><br>In mirror_map.... should we put all read requests into the read bio_list of the <br>mirror_set after check the return value from log-&gt;type-&gt;in_sync(), since 
<br>do_read() method does the same thing and it will be invoke when a do_work <br>is invoke? Or shoulwe d move all read actions including the checking <br>(in mirror_map) to the do_read() function ?<br><br>----------------------------------------------------------------
<br><br>Thanks for all...<br>and please forgive my Chinese English..... is too poor....<br>(hopes some one understand what I am talking about in above...)<br><br>regard.<br>

------=_Part_3151_27532351.1176457747801--


--===============1424928889==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1424928889==--
