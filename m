From: Neeraj Soni <neersoni@codeaurora.org>
Subject: Re: dm: submit stacked requests in irq enabled context
Date: Tue, 9 May 2017 15:19:31 +0530
Message-ID: <dee12838-7b43-2fdd-0644-41c10ecf9148@codeaurora.org>
References: <a66b6e17-a8c4-3465-fc2e-c3114abe0ca7@codeaurora.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5304211481585342761=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <a66b6e17-a8c4-3465-fc2e-c3114abe0ca7@codeaurora.org>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: keith.busch@intel.com, snitzer@redhat.com
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============5304211481585342761==
Content-Type: multipart/alternative;
	boundary="------------4093A8D07BE47899019D6DDA"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------4093A8D07BE47899019D6DDA
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

+ Alasdair and dm-devel for awareness and inputs.


On 5/9/2017 12:26 PM, Neeraj Soni wrote:
> Hi Keith/Snitzer,
>
> I have recently started using kernel 4.4 on a Android device and ran 
> Androbench to check storage read/write performance. I found that the 
> Random Read (RR) and Random write(RW) performance with Full Disk 
> Encryption is degraded compared to no Disk Encryption. Initially i 
> thought this must the issue with the storage part used and i compared 
> the performance of similar storage part on a device that was using 
> Android with kernel 3.18. I found that with no Disk Encryption the 
> performance was equivalent to the device which was using 4.4 but with 
> Disk Encryption there was degradation in RR (~20%) and RW(10%).
>
> I then tried to compare the changes that was brought in kernel 4.4 in 
> Full Disk Encryption path. I came across the patch mentioned in 
> subject and found that now a worker thread is scheduled in 
> dm_request_fn() to process the requests instead of directly invoking 
> map_request() as was in kernel 3.18.
>
> I reverted this patch and found that the RR and RW performance was now 
> closer to what we have without Disk Encryption. From the commit 
> message i understand that this change is significant and will be 
> required for blk-mq support but have you came across such degradation 
> issue with your patch and do we have any fix for this degradation 
> available?
>
> BR,
> Neeraj Soni,
> --

Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
     a Linux Foundation Collaborative Project




--------------4093A8D07BE47899019D6DDA
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body text="#000000" bgcolor="#FFFFFF">
    <p>+ Alasdair and dm-devel for awareness and inputs.<br>
    </p>
    <br>
    <div class="moz-cite-prefix">On 5/9/2017 12:26 PM, Neeraj Soni
      wrote:<br>
    </div>
    <blockquote type="cite"
      cite="mid:a66b6e17-a8c4-3465-fc2e-c3114abe0ca7@codeaurora.org">Hi
      Keith/Snitzer,
      <br>
      <br>
      I have recently started using kernel 4.4 on a Android device and
      ran Androbench to check storage read/write performance. I found
      that the Random Read (RR) and Random write(RW) performance with
      Full Disk Encryption is degraded compared to no Disk Encryption.
      Initially i thought this must the issue with the storage part used
      and i compared the performance of similar storage part on a device
      that was using Android with kernel 3.18. I found that with no Disk
      Encryption the performance was equivalent to the device which was
      using 4.4 but with Disk Encryption there was degradation in RR
      (~20%) and RW(10%).
      <br>
      <br>
      I then tried to compare the changes that was brought in kernel 4.4
      in Full Disk Encryption path. I came across the patch mentioned in
      subject and found that now a worker thread is scheduled in
      dm_request_fn() to process the requests instead of directly
      invoking map_request() as was in kernel 3.18.
      <br>
      <br>
      I reverted this patch and found that the RR and RW performance was
      now closer to what we have without Disk Encryption. From the
      commit message i understand that this change is significant and
      will be required for blk-mq support but have you came across such
      degradation issue with your patch and do we have any fix for this
      degradation available?
      <br>
      <br>
      BR,
      <br>
      Neeraj Soni,</blockquote>
    <blockquote type="cite"
      cite="mid:a66b6e17-a8c4-3465-fc2e-c3114abe0ca7@codeaurora.org">--<br>
    </blockquote>
    <style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:"Segoe UI";
	panose-1:2 11 5 2 4 2 4 2 2 3;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin-top:0in;
	margin-right:0in;
	margin-bottom:8.0pt;
	margin-left:0in;
	line-height:107%;
	font-size:11.0pt;
	font-family:"Calibri",sans-serif;}
.MsoChpDefault
	{font-family:"Calibri",sans-serif;}
.MsoPapDefault
	{margin-bottom:8.0pt;
	line-height:107%;}
 /* Page Definitions */
 @page WordSection1
	{size:8.5in 11.0in;
	margin:1.0in 1.0in 1.0in 1.0in;}
div.WordSection1
	{page:WordSection1;}
-->
</style>
    <div class="WordSection1">
      <p class="MsoNormal"
        style="margin-top:2.0pt;margin-right:0in;margin-bottom:2.0pt;
        margin-left:0in;line-height:normal;text-autospace:none"><span
          style="font-size:
          12.0pt;font-family:&quot;Times New Roman&quot;,serif">  
          Qualcomm Innovation Center, Inc. is
          a member of Code Aurora Forum, <br>
              a Linux Foundation Collaborative Project</span><span
          style="font-size:10.0pt;
          font-family:&quot;Segoe UI&quot;,sans-serif;color:black"> </span><span
          style="font-size:
          10.0pt;font-family:&quot;Segoe
          UI&quot;,sans-serif;color:black"> </span></p>
    </div>
    <br>
    <br>
  </body>
</html>

--------------4093A8D07BE47899019D6DDA--


--===============5304211481585342761==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5304211481585342761==--
