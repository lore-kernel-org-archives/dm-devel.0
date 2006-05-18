From: Richard Keech <rkeech@redhat.com>
Subject: Re: [Consult-list] Re: dm-multipath has great	throughput
	but we'd like more!
Date: Thu, 18 May 2006 20:28:17 +1000
Message-ID: <446C4C41.2030705@redhat.com>
References: <1147935929.27006.57.camel@baggage>	
	<d2c2bb37e4e03a0daa7ee7e5803174cd@redhat.com>	
	<1147938254.27006.65.camel@baggage>	
	<1147939464.3183.15.camel@nstrug.surrey.redhat.com>
	<1147945356.3183.39.camel@nstrug.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0382342279=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1147945356.3183.39.camel@nstrug.surrey.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Nicholas C. Strugnell" <nstrug@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, consult-list@redhat.com
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============0382342279==
Content-Type: multipart/alternative;
	boundary="------------070802000101030301050001"

This is a multi-part message in MIME format.
--------------070802000101030301050001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Nicholas C. Strugnell wrote:

>On Thu, 2006-05-18 at 10:04 +0200, Nicholas C. Strugnell wrote: 
>  
>
>>On Thu, 2006-05-18 at 08:44 +0100, Bob Gautier wrote:
>>    
>>
>>>On Thu, 2006-05-18 at 02:25 -0500, Jonathan E Brassow wrote:
>>>      
>>>
>>>>The system bus isn't a limiting factor is it?  64-bit PCI-X will get 
>>>>8.5 GB/s (plenty), but 32-bit PCI 33MHz got 133MB/s.
>>>>
>>>>Can your disks sustain that much bandwidth? 10 striped drives might get 
>>>>better than 200MB/s if done right, I suppose.
>>>>
>>>>        
>>>>
>
>  
>
>>It might make sense to test raw writes to a device with dd and see if
>>that gets comparable performance figures - I'll just try that myself
>>actually.
>>    
>>
>
>write throughput to EVA 8000 (8GB write cache), host DL380 with 2x2Gb/s
>HBAs, 2GB RAM
>
>testing 4GB files:
>
>on filesystems: bonnie++ -d /mnt/tmp -s 4g -f -n 0 -u root
>
>ext3: 129MB/s sd=0.43
>  
>
I presume this is with journal=ordered.  Try with journel=writeback.  
I've seen benchmarks which suggest it can be close to the speed of ext2.

-- 
Red Hat Home
www.redhat.com.au <http://www.redhat.com>

	
	
	
*Richard Keech*
Chief Technology Architect
Red Hat Asia-Pacific
email: rkeech@redhat.com <mailto:rkeech@redhat.com>
mobile: +61 419 036 463
	
	Level 50, 120 Collins Street
Melbourne VIC  3000
phone: +61 3 9225 5258
fax: +61 3 9225 5050
support: 1800 733 428
	

	
	
	


--------------070802000101030301050001
Content-Type: multipart/related;
	boundary="------------000605030000080000010301"


--------------000605030000080000010301
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta content="text/html;charset=ISO-8859-1" http-equiv="Content-Type">
  <title></title>
</head>
<body bgcolor="#ffffff" text="#000000">
Nicholas C. Strugnell wrote:
<blockquote cite="mid1147945356.3183.39.camel@nstrug.surrey.redhat.com"
 type="cite">
  <pre wrap="">On Thu, 2006-05-18 at 10:04 +0200, Nicholas C. Strugnell wrote: 
  </pre>
  <blockquote type="cite">
    <pre wrap="">On Thu, 2006-05-18 at 08:44 +0100, Bob Gautier wrote:
    </pre>
    <blockquote type="cite">
      <pre wrap="">On Thu, 2006-05-18 at 02:25 -0500, Jonathan E Brassow wrote:
      </pre>
      <blockquote type="cite">
        <pre wrap="">The system bus isn't a limiting factor is it?  64-bit PCI-X will get 
8.5 GB/s (plenty), but 32-bit PCI 33MHz got 133MB/s.

Can your disks sustain that much bandwidth? 10 striped drives might get 
better than 200MB/s if done right, I suppose.

        </pre>
      </blockquote>
    </blockquote>
  </blockquote>
  <pre wrap=""><!---->
  </pre>
  <blockquote type="cite">
    <pre wrap="">It might make sense to test raw writes to a device with dd and see if
that gets comparable performance figures - I'll just try that myself
actually.
    </pre>
  </blockquote>
  <pre wrap=""><!---->
write throughput to EVA 8000 (8GB write cache), host DL380 with 2x2Gb/s
HBAs, 2GB RAM

testing 4GB files:

on filesystems: bonnie++ -d /mnt/tmp -s 4g -f -n 0 -u root

ext3: 129MB/s sd=0.43
  </pre>
</blockquote>
I presume this is with journal=ordered.&nbsp; Try with journel=writeback.&nbsp;
I've seen benchmarks which suggest it can be close to the speed of ext2.<br>
<br>
<div class="moz-signature">-- <br>
<table style="width: 800px; height: 122px;" cellspacing="0">
  <tbody>
    <tr>
      <td style="width: 200px;"><img
 src="cid:part1.05040000.03080906@redhat.com" alt="Red Hat Home"
 id="rhLogo" height="31" width="96"><br>
      <font size="-1"><a href="http://www.redhat.com"><span
 style="font-family: helvetica,arial,sans-serif;">www.redhat.com.au</span></a><br
 style="font-family: helvetica,arial,sans-serif;">
      </font><br>
      </td>
      <td style="width: 200px;"> <br>
      </td>
      <td style="vertical-align: top; width: 200px;"><br>
      </td>
      <td style="vertical-align: top; width: 200px; text-align: center;"><br>
      </td>
    </tr>
    <tr>
      <td
 style="vertical-align: top; font-family: helvetica,arial,sans-serif; width: 200px;">
      <font color="#ff0000" size="-1"><b>Richard Keech</b></font><font
 size="-1"><br>
      <span style="font-weight: bold;">Chief Technology Architect</span><br>
Red Hat Asia-Pacific<br>
email: <a href="mailto:rkeech@redhat.com">rkeech@redhat.com</a><br>
mobile: +61 419 036 463<br>
      </font></td>
      <td style="vertical-align: top; width: 200px;"><br>
      </td>
      <td
 style="vertical-align: top; font-family: helvetica,arial,sans-serif; width: 200px;"><font
 size="-1">Level 50, 120 Collins Street<br>
Melbourne VIC&nbsp; 3000<br>
phone: +61 3 9225 5258<br>
fax: +61 3 9225 5050<br>
support: 1800 733 428<br>
      </font> </td>
      <td style="vertical-align: top; width: 200px;"><br>
      </td>
    </tr>
    <tr height="8">
      <td
 style="background-color: rgb(255, 0, 0); height: 8px; width: 200px;"> <br>
      </td>
      <td style="height: 8px; width: 200px;" bgcolor="#ff0000"> <br>
      </td>
      <td
 style="vertical-align: top; background-color: rgb(255, 0, 0); height: 8px; width: 200px;"><br>
      </td>
      <td
 style="vertical-align: top; background-color: rgb(255, 0, 0); height: 8px; width: 200px;"><br>
      </td>
    </tr>
  </tbody>
</table>
</div>
</body>
</html>

--------------000605030000080000010301
Content-Type: image/png;
 name="logo_rh_home.png"
Content-Transfer-Encoding: base64
Content-ID: <part1.05040000.03080906@redhat.com>
Content-Disposition: inline;
 filename="logo_rh_home.png"

iVBORw0KGgoAAAANSUhEUgAAAGAAAAAfCAMAAAAvMjgeAAAAA3NCSVQICAjb4U/gAAAAz1BM
VEUAAADc3NxqamqSAAAzMzOtra1EAACUn58YGBj///9JSUnjAADVAADFxcUUAADMAACDg4OF
AADv7+/FAAByAQFUXV0PDw9CQkK8AABneHjV1dUABQW9vb1rAACtAAAnAAD4+PghISGVlZWm
pqZVAADn5+czPT1mZma2trZQUFDMzMx3FRU7S0sFAAB1dXWeAAAqKipLYmKNjY1cAADdAAB5
eXlDUlK0AACLAAAbAABMAQEzAAB+AAAJCQlmAAArISGZmZk5OTlwZ2daWlqnAQGIirNOAAAA
CXBIWXMAAArwAAAK8AFCrDSYAAAAJXRFWHRTb2Z0d2FyZQBNYWNyb21lZGlhIEZpcmV3b3Jr
cyBNWCAyMDA0h3aszwAAA4lJREFUeJzVlWt/ojgUhw8CLnFQKXWBFeokRobLVpdBHS+VLi79
/p9pTwKorTPTzm99s+eFxATOk/zPJUBao0HEQBirYkpuZtA87dyBsxV5eFsAjXHz89oGgwEi
nNK+IcC2xLb3h+1yuTxM1NGT+Nu5zSEEwI6Ew5m5MlerlbmZHYafxUR1E4IArKXuqndvmuZw
OFQPpjoXM9EtVEJALP3vJqPZ6LBFAGK8rpwrbwKwM+ms602eus+joTTzTh6Bjd938F5GA8nr
zJzdr7xaIgGYyChA9H5BrCP+01gBNWD3sN1uuwcM8vBkMwlw3o9zBoZO4vjHgABgizs3u/P9
3WTVMswRfDAKR3A46VTfWVEUCYhgsBFehSifn/YvDUB9fhZh6H0QkFwv2L1cCAxYwg+fhM/N
s6jgXSPRxBtusN6K5m2qKJSksrpTzpVmNuABcVtA2M6GSi0sy+UJ0AZbSRh6d935/HARiB1A
UwoBM/jacBSSZkZRGLJCeOY4TpbVEqXM950pbpkbBSt6IbEc8B1HlwAYnLx6L+rZ/2o/nwc1
IHaAYTdUFPxhBvioOW+7IwIWxTEPw47fx2kc9FmPUoUtwpCS5qWud7Hx1j6hRvEJgL2jg4pD
TMMKWBDisFJElxGAOhuyqklrnQXEZhZtJBL295/eW//mXxiU8wmAEzJ2ICKUYublgQOZUJ1J
iTIp+yKrFaUBK98A8Mj/PGzuXwE2otjsE+CI7soCDE3TmA/5FEA6uMwiruHrYV5pmXMG1LdY
hGn72+Ne3XgtxFMxxODTE8CtAX5RFBjcKTaA/C2gRIDuZxa3jDOgKhzmVpqU4ncfnpYH9eVF
HS13EuxeARKdo5UKXiFrsai9BoRiryS9kGi8LlNCppXUYqF9+fbH49evj9/815XcAFIHtEY0
HfMKkwbT6hJAc3mD9S9O0HhI6zJpmxtv7mb7NYD0AI56EE+nJHRxyLkGbwHiEwsEYE0uACfj
Uz0ltFMDOrwFAGgCMNbqBaYQ3ZCjo0ivqG4pZWYrThLEloFBJonG9TC/AlhakhJMcrdaRFUY
tQesEktm4njhZlnmWkjTE01zrX5S9UkpuwIJMCo8S5KktHTUqedq6fEKIHtKDhH2HmKT06Vp
2616Spo2etpjMbDxHVovyofS7+N3YhSmfWpfA8R+3Z9fIr9i3wOEnR/fHzcB0A9cxf8JcFP7
/wP+BbU7qQpvLpa/AAAAAElFTkSuQmCC
--------------000605030000080000010301--

--------------070802000101030301050001--


--===============0382342279==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0382342279==--
