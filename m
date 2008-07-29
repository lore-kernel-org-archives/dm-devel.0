From: Sajesh Singh <ssingh@amnh.org>
Subject: Re: Pathvec messages
Date: Tue, 29 Jul 2008 15:43:32 -0400
Message-ID: <488F72E4.7020506@amnh.org>
References: <488F4A9E.6020906@amnh.org>
	<20080729170455.GE30728@ether.msp.redhat.com>
	<488F54B7.6030600@amnh.org>
	<20080729190735.GF30728@ether.msp.redhat.com>
Reply-To: ssingh@amnh.org, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0828933786=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080729190735.GF30728@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============0828933786==
Content-Type: multipart/alternative;
	boundary="------------030902020106030500050000"

This is a multi-part message in MIME format.
--------------030902020106030500050000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit



Benjamin Marzinski wrote:
> On Tue, Jul 29, 2008 at 01:34:47PM -0400, Sajesh Singh wrote:
>   
>>  
>>    Benjamin Marzinski wrote:
>>
>>  On Tue, Jul 29, 2008 at 12:51:42PM -0400, Sajesh Singh wrote:
>>
>>
>>  Whenever I run the multipath -v3 command on a EL 5 server I see the
>>  following line in the output for each device.
>>
>>  sdc: not found in pathvec
>>
>>
>>  This simply means that the device is not already stored in multipath's
>>  in memory list of discovered paths. It's completely normal to see this
>>  for your all your devices when running the multipath command.
>>
>>  -Ben
>>
>>
>>
>>    That being said, when does the device make it into the memory list of
>>    discovered paths ?
>>     
>
> Immediately after multipath realizes that it's not there.  In
> multipathd, which uses the same code, you will see this when multipath
> first spots a new device.  After that, the device will be list of
> discovered paths. 
>
> -Ben
>   
So running multipath -v3 multiple times and seeing the output of "not 
found in pathvec" is merely informational?
>  
>   
>>  I have seen questions on this before, but no answer as to what this means.
>>  Is the message merely information or does the multipath configuration need
>>  to be changed?
>>
>>  Regards,
>>
>>  Sajesh
>>
>>  --
>>  dm-devel mailing list
>>  [2]dm-devel@redhat.com
>>  [3]https://www.redhat.com/mailman/listinfo/dm-devel
>>
>>
>> References
>>
>>    Visible links
>>    1. mailto:dm-devel@redhat.com
>>    2. https://www.redhat.com/mailman/listinfo/dm-devel
>>     

--------------030902020106030500050000
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<br>
<br>
Benjamin Marzinski wrote:
<blockquote cite="mid:20080729190735.GF30728@ether.msp.redhat.com"
 type="cite">
  <pre wrap="">On Tue, Jul 29, 2008 at 01:34:47PM -0400, Sajesh Singh wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap=""> 
   Benjamin Marzinski wrote:

 On Tue, Jul 29, 2008 at 12:51:42PM -0400, Sajesh Singh wrote:


 Whenever I run the multipath -v3 command on a EL 5 server I see the
 following line in the output for each device.

 sdc: not found in pathvec


 This simply means that the device is not already stored in multipath's
 in memory list of discovered paths. It's completely normal to see this
 for your all your devices when running the multipath command.

 -Ben



   That being said, when does the device make it into the memory list of
   discovered paths ?
    </pre>
  </blockquote>
  <pre wrap=""><!---->
Immediately after multipath realizes that it's not there.  In
multipathd, which uses the same code, you will see this when multipath
first spots a new device.  After that, the device will be list of
discovered paths. 

-Ben
  </pre>
</blockquote>
So running multipath -v3 multiple times and seeing the output of "not
found in pathvec" is merely informational?<br>
<blockquote cite="mid:20080729190735.GF30728@ether.msp.redhat.com"
 type="cite">
  <pre wrap=""> 
  </pre>
  <blockquote type="cite">
    <pre wrap=""> I have seen questions on this before, but no answer as to what this means.
 Is the message merely information or does the multipath configuration need
 to be changed?

 Regards,

 Sajesh

 --
 dm-devel mailing list
 [<a class="moz-txt-link-abbreviated" href="mailto:2]dm-devel@redhat.com">2]dm-devel@redhat.com</a>
 [3]<a class="moz-txt-link-freetext" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a>


References

   Visible links
   1. <a class="moz-txt-link-freetext" href="mailto:dm-devel@redhat.com">mailto:dm-devel@redhat.com</a>
   2. <a class="moz-txt-link-freetext" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a>
    </pre>
  </blockquote>
</blockquote>
</body>
</html>

--------------030902020106030500050000--


--===============0828933786==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0828933786==--
