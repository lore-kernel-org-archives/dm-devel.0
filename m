From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: understanding of multipathing and speed
Date: Tue, 06 Jul 2010 10:25:00 +0200
Message-ID: <1278404700.26874.5.camel@Nokia-N900-42-11>
References: <485728250.294571278403626576.JavaMail.root@tendai.telenet-ops.be>
Reply-To: Christophe Varoqui <christophe.varoqui@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============3072300428871280329=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <485728250.294571278403626576.JavaMail.root@tendai.telenet-ops.be>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: bart.coninckx@telenet.be
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


--===============3072300428871280329==
Content-Type: multipart/alternative; boundary="=-Fw3dy9m6bg0lUcp79Dw1"


--=-Fw3dy9m6bg0lUcp79Dw1
Content-Type: text/plain; charset=utf-8
Content-ID: <1278404698.26874.2.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

> routing points to the correct interface per network. Maybe my test
> (bonnie++) 
> 
> is not an appropriate one to show the difference in speed? 
> 
an interesting data point would be a perf run when iet target has only one target port on a bonded interface a multipath on client side.

And maybe the other combinations. Th eset combinations would be :
- client bonded, target not bonded
- client bonded, target bonded (i understand this is the scenario with good performance you reported earlier)
- client not bonded, target not bonded (perf expected from a single path in your testing)
- client not bonded, target bonded

the mixed setup would not be adequate for production as they require linked or single switch setups, but the information might help determine if the performance drop is due to multipath or iet multi-target.

Bye.
--=-Fw3dy9m6bg0lUcp79Dw1
Content-Type: text/html; charset=utf-8
Content-ID: <1278404698.26874.4.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="generator" content="Osso Notes">
    <title></title></head>
<body>
<p>&gt; routing points to the correct interface per network. Maybe my test
<br>&gt; (bonnie++) 
<br>&gt; 
<br>&gt; is not an appropriate one to show the difference in speed? 
<br>&gt; 
<br>an interesting data point would be a perf run when iet target has only one target port on a bonded interface a multipath on client side.
<br>
<br>And maybe the other combinations. Th eset combinations would be :
<br>- client bonded, target not bonded
<br>- client bonded, target bonded (i understand this is the scenario with good performance you reported earlier)
<br>- client not bonded, target not bonded (perf expected from a single path in your testing)
<br>- client not bonded, target bonded
<br>
<br>the mixed setup would not be adequate for production as they require linked or single switch setups, but the information might help determine if the performance drop is due to multipath or iet multi-target.
<br>
<br>Bye.</p>
</body>
</html>

--=-Fw3dy9m6bg0lUcp79Dw1--


--===============3072300428871280329==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============3072300428871280329==--
