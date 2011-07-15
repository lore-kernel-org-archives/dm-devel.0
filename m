From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipath: add find_multipaths feature.
Date: Fri, 15 Jul 2011 09:03:07 +0200
Message-ID: <1310713387.2215.5.camel@Nokia-N900-42-11>
References: <20101116232546.GU13763@ether.msp.redhat.com>
	<1291762849.4430.6.camel@zezette> <20110715005302.GA26472@redhat.com>
Reply-To: Christophe Varoqui <christophe.varoqui@gmail.com>,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6787038915539165840=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110715005302.GA26472@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


--===============6787038915539165840==
Content-Type: multipart/alternative; boundary="=-ai/0rMFatZscMj2EBd2e"


--=-ai/0rMFatZscMj2EBd2e
Content-Type: text/plain; charset=utf-8
Content-ID: <1310713386.2215.2.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

On ven. 15 juil. 2011 02:53:03 CEST, Mike Snitzer <snitzer@redhat.com> wrote:
> 
> find_multipaths is quite useful for avoiding the issue that was just
> reported where multipath grabs the root device even though it doesn't
> have multiple paths.
> 
> Any chance you could reevaluate Ben's patch for inclusion?

Sure, I'll look into merging this patch. Do you have a rebased versin around ?

Also, will you provide a way to install a multipathed root system when there is only one path available ? Does breaking into the shell to force multpath creation during anaconda work ?

Regards,
cvaroqui

--=-ai/0rMFatZscMj2EBd2e
Content-Type: text/html; charset=utf-8
Content-ID: <1310713386.2215.4.camel@Nokia-N900-42-11>
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html><head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
    <meta name="generator" content="Osso Notes">
    <title></title></head>
<body>
<p>On ven. 15 juil. 2011 02:53:03 CEST, Mike Snitzer &lt;<a href="mailto:snitzer@redhat.com">snitzer@redhat.com</a>&gt; wrote:
<br>&gt; 
<br>&gt; find_multipaths is quite useful for avoiding the issue that was just
<br>&gt; reported where multipath grabs the root device even though it doesn't
<br>&gt; have multiple paths.
<br>&gt; 
<br>&gt; Any chance you could reevaluate Ben's patch for inclusion?
<br>
<br>Sure, I'll look into merging this patch. Do you have a rebased versin around ?
<br>
<br>Also, will you provide a way to install a multipathed root system when there is only one path available ? Does breaking into the shell to force multpath creation during anaconda work ?
<br>
<br>Regards,
<br>cvaroqui<br></p>
</body>
</html>

--=-ai/0rMFatZscMj2EBd2e--


--===============6787038915539165840==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============6787038915539165840==--
