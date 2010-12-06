From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipathing in debian lenny with sychronized
	data	between 2 servers
Date: Mon, 06 Dec 2010 20:01:14 +0100
Message-ID: <1291662074.1518.5.camel@Nokia-N900-42-11>
References: <AANLkTik9tVk9sY-YyC+uAOTnMOuBw8DU3sozE2o=DKk1@mail.gmail.com>
Reply-To: Christophe Varoqui <christophe.varoqui@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7347704369772880648=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AANLkTik9tVk9sY-YyC+uAOTnMOuBw8DU3sozE2o=DKk1@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>, Oliver Rojo <orojo.horus@gmail.com>
List-Id: dm-devel.ids


--===============7347704369772880648==
Content-Type: multipart/alternative; boundary="=-LoE+NV0LaN/9Am1U2l2p"


--=-LoE+NV0LaN/9Am1U2l2p
Content-Type: text/plain; charset=utf-8
Content-ID: <1291662073.1518.2.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit


> I'm having issues right now using HP Storageworks P2000 G3 MSA with Dual
> Fiber Channel connected on each host (2 Servers). I've already configure
> multipathing and mounted my multipath alias (/dev/mapper/data to /data)
> but everytime I put some data inside /data/ on Server 1, it doesn't
> reflect on Server2 and vice versa. Is there any tweak on this?
> 
have you tested that without multipathing ?

I understand you use a filesystem there ... A clustered fs like ocfs2 or gfs2 would be necessary to synchronize your caches. If you are not using one of those, the fs should be mounted on a single node at a time.

Regards,
cvaroqui,
opensvc
--=-LoE+NV0LaN/9Am1U2l2p
Content-Type: text/html; charset=utf-8
Content-ID: <1291662073.1518.4.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="generator" content="Osso Notes">
    <title></title></head>
<body>
<p>
<br>&gt; I'm having issues right now using HP Storageworks P2000 G3 MSA with Dual
<br>&gt; Fiber Channel connected on each host (2 Servers). I've already configure
<br>&gt; multipathing and mounted my multipath alias (/dev/mapper/data to /data)
<br>&gt; but everytime I put some data inside /data/ on Server 1, it doesn't
<br>&gt; reflect on Server2 and vice versa. Is there any tweak on this?
<br>&gt; 
<br>have you tested that without multipathing ?
<br>
<br>I understand you use a filesystem there ... A clustered fs like ocfs2 or gfs2 would be necessary to synchronize your caches. If you are not using one of those, the fs should be mounted on a single node at a time.
<br>
<br>Regards,
<br>cvaroqui,
<br>opensvc</p>
</body>
</html>

--=-LoE+NV0LaN/9Am1U2l2p--


--===============7347704369772880648==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============7347704369772880648==--
