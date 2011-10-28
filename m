From: Yathindra <ydev@cs.utah.edu>
Subject: Mapping sectors to have errors
Date: Thu, 27 Oct 2011 20:31:00 -0600
Message-ID: <4EAA13E4.6020709@cs.utah.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============9051337028617518727=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Yathindra Naik <ydev@cs.utah.edu>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--===============9051337028617518727==
Content-Type: multipart/alternative;
	boundary="------------070204010803090908040707"

This is a multi-part message in MIME format.
--------------070204010803090908040707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I'm trying to create a disk and map some sectors to have errors on them.

I tried this,
echo "0 100000 linear /dev/sdb 0 100000 480081250 error"| dmsetup create 
bad_disk
device-mapper: reload ioctl failed: Invalid argument
Command failed

I have put in the right arguments but not sure why it fails.

Could someone please guide me how I can do this.

Thanks,
Yathi

--------------070204010803090908040707
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    Hi,<br>
    <br>
    <font size="3">I'm trying to create a disk and map some sectors to
      have errors on them. <br>
      <br>
      I tried this,<br>
    </font><font size="3">echo "0 100000 linear /dev/sdb 0 100000
      480081250 error"| dmsetup create bad_disk <br>
    </font><font size="3">device-mapper: reload ioctl failed: Invalid
      argument<br>
    </font><font size="3">Command failed</font><br>
    <br>
    <font size="3">I have put in the right arguments but not sure why it
      fails.<br>
      <br>
      Could someone please guide me how I can do this.<br>
      <br>
      Thanks,<br>
      Yathi<br>
    </font>
  </body>
</html>

--------------070204010803090908040707--


--===============9051337028617518727==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============9051337028617518727==--
