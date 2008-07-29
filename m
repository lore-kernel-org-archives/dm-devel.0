From: Sajesh Singh <ssingh@amnh.org>
Subject: Re: Pathvec messages
Date: Tue, 29 Jul 2008 13:34:47 -0400
Message-ID: <488F54B7.6030600@amnh.org>
References: <488F4A9E.6020906@amnh.org>
	<20080729170455.GE30728@ether.msp.redhat.com>
Reply-To: ssingh@amnh.org, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0811988780=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080729170455.GE30728@ether.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, bmarzins@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============0811988780==
Content-Type: multipart/alternative;
	boundary="------------020703000906040005000208"

This is a multi-part message in MIME format.
--------------020703000906040005000208
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


________________________________________________________
Sajesh Singh                           
Senior Systems Administrator                   
American Museum of Natural History     
Central Park West at 79th Street       
New York, NY 10024                     
                                       
(O) (212) 313-7263                     
(C) (917) 577-9195                     
(E) ssingh@amnh.org



Benjamin Marzinski wrote:
> On Tue, Jul 29, 2008 at 12:51:42PM -0400, Sajesh Singh wrote:
>   
>> Whenever I run the multipath -v3 command on a EL 5 server I see the 
>> following line in the output for each device.
>>
>> sdc: not found in pathvec
>>     
>
> This simply means that the device is not already stored in multipath's
> in memory list of discovered paths. It's completely normal to see this
> for your all your devices when running the multipath command.
>
> -Ben
>
>   
That being said, when does the device make it into the memory list of 
discovered paths ?
>> I have seen questions on this before, but no answer as to what this means. 
>> Is the message merely information or does the multipath configuration need 
>> to be changed?
>>
>> Regards,
>>
>> Sajesh
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://www.redhat.com/mailman/listinfo/dm-devel
>>     

--------------020703000906040005000208
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
</head>
<body bgcolor="#ffffff" text="#000000">
<br>
<pre class="moz-signature" cols="72">________________________________________________________
Sajesh Singh                           
Senior Systems Administrator                   
American Museum of Natural History     
Central Park West at 79th Street       
New York, NY 10024                     
                                       
(O) (212) 313-7263                     
(C) (917) 577-9195                     
(E) <a class="moz-txt-link-abbreviated" href="mailto:ssingh@amnh.org">ssingh@amnh.org</a></pre>
<br>
<br>
Benjamin Marzinski wrote:
<blockquote cite="mid:20080729170455.GE30728@ether.msp.redhat.com"
 type="cite">
  <pre wrap="">On Tue, Jul 29, 2008 at 12:51:42PM -0400, Sajesh Singh wrote:
  </pre>
  <blockquote type="cite">
    <pre wrap="">Whenever I run the multipath -v3 command on a EL 5 server I see the 
following line in the output for each device.

sdc: not found in pathvec
    </pre>
  </blockquote>
  <pre wrap=""><!---->
This simply means that the device is not already stored in multipath's
in memory list of discovered paths. It's completely normal to see this
for your all your devices when running the multipath command.

-Ben

  </pre>
</blockquote>
That being said, when does the device make it into the memory list of
discovered paths ?<br>
<blockquote cite="mid:20080729170455.GE30728@ether.msp.redhat.com"
 type="cite">
  <pre wrap=""></pre>
  <blockquote type="cite">
    <pre wrap="">I have seen questions on this before, but no answer as to what this means. 
Is the message merely information or does the multipath configuration need 
to be changed?

Regards,

Sajesh

--
dm-devel mailing list
<a class="moz-txt-link-abbreviated" href="mailto:dm-devel@redhat.com">dm-devel@redhat.com</a>
<a class="moz-txt-link-freetext" href="https://www.redhat.com/mailman/listinfo/dm-devel">https://www.redhat.com/mailman/listinfo/dm-devel</a>
    </pre>
  </blockquote>
</blockquote>
</body>
</html>

--------------020703000906040005000208--


--===============0811988780==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0811988780==--
