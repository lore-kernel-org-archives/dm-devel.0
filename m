From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: dm snapshot diffs
Date: Fri, 20 May 2011 09:53:55 +0200
Message-ID: <1305878035.21413.5.camel@Nokia-N900-42-11>
References: <120681305744449@web11.yandex.ru>
Reply-To: Christophe Varoqui <christophe.varoqui@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============5094436857257373584=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <120681305744449@web11.yandex.ru>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Groshev Dmitry <a2alt@ya.ru>
List-Id: dm-devel.ids


--===============5094436857257373584==
Content-Type: multipart/alternative; boundary="=-VknWFaurRpeUfBX/eAWq"


--=-VknWFaurRpeUfBX/eAWq
Content-Type: text/plain; charset=utf-8
Content-ID: <1305878034.21413.2.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

On mer. 18 mai 2011 20:47:28 CEST, Groshev Dmitry <a2alt@ya.ru> wrote:

> Hello. I' m using LVM with snapshots on a big storage and for some
> reason I need to get some information that bare LVM doesn't provide. Is
> there a way to get a list of blocks that was changed since the snapshot
> was created? I see that snapshot-cow device if being filled, but how I
> can find a "old block in origin -> new block in cow" mapping?
> 
you may want to look at dds in the www.opensvc.com git repo.
This small tool parse the lvm2 snapshot cow table format.


--=-VknWFaurRpeUfBX/eAWq
Content-Type: text/html; charset=utf-8
Content-ID: <1305878034.21413.4.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="generator" content="Osso Notes">
    <title></title></head>
<body>
<p>On mer. 18 mai 2011 20:47:28 CEST, Groshev Dmitry &lt;<a href="mailto:a2alt@ya.ru">a2alt@ya.ru</a>&gt; wrote:
<br>
<br>&gt; Hello. I' m using LVM with snapshots on a big storage and for some
<br>&gt; reason I need to get some information that bare LVM doesn't provide. Is
<br>&gt; there a way to get a list of blocks that was changed since the snapshot
<br>&gt; was created? I see that snapshot-cow device if being filled, but how I
<br>&gt; can find a "old block in origin -&gt; new block in cow" mapping?
<br>&gt; 
<br>you may want to look at dds in the <a href="http://www.opensvc.com">www.opensvc.com</a> git repo.
<br>This small tool parse the lvm2 snapshot cow table format.
<br><br></p>
</body>
</html>

--=-VknWFaurRpeUfBX/eAWq--


--===============5094436857257373584==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============5094436857257373584==--
