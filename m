From: Malahal Naineni <malahal@us.ibm.com>
Subject: Re: multipath: change the DEFAULT_MINIO for the request
 based multipath
Date: Tue, 1 Feb 2011 00:13:03 -0800
Message-ID: <20110201081303.GA31174@us.ibm.com>
References: <4D37E513.3070506@suse.de> <20110120160726.GA23529@redhat.com>
	<4D392FBD.5080207@ce.jp.nec.com>
	<1295599627.23625.16.camel@zezette>
	<20110121141204.GE30411@redhat.com>
	<1295621193.23625.37.camel@zezette>
	<20110121173930.GB20278@us.ibm.com>
	<4D3E9020.6010009@ce.jp.nec.com> <20110126022307.GA512@us.ibm.com>
	<1296518031.6483.106.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1296518031.6483.106.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

>Christophe Varoqui [christophe.varoqui@gmail.com] wrote:

>+dm_drv_get_rq (void)
>+{
>+	unsigned int minv_dmrq[3] = {1, 1, 0};
>+	unsigned int *v;
>+
>+	v = zalloc(3);
>+	if (!v)
>+		return 0;
>+
>+	if (dm_drv_version(v, TGT_MPATH)) {
>+		/* in doubt return least capable */
>+		return 0;
>+	}

Looks like the 'v' is NOT freed. Local stack allocation looks much
cleaner, why not do that? You missed the same thing at other places, so
I imagine you started with the on stack local structure but changed
later???

>+static int
>+dm_drvprereq (char * str)
>+{
>+	unsigned int minv[3] = {1, 0, 3};
>+	unsigned int *v;
>+
>+	v = zalloc(3);
>+	if (!v)
>+		return 0;
>+
>+	if (dm_drv_version(v, str)) {
>+		/* in doubt return not capable */
>+		return 1;
>+	}

Missed freeing 'v'. Also, this function taking the target driver name as
'str' doesn't make sense as the minimum version is hard coded internally
to this function. Take no arguments and pass 'TGT_MPATH' while calling
dm_drv_version.

> static int
>+def_minio_rq_handler(vector strvec)
>+{
>+	char * buff;
>+
>+	buff = set_value(strvec);
>+
>+	if (!buff)
>+		return 1;
>+
>+	conf->minio_rq = atoi(buff);
>+	FREE(buff);
>+
>+	return 0;
>+}

I was thinking why introduce minio and minio_rq in the
/etc/multipath.conf file. By default we ship empty /etc/multipath.conf
file. If the admin wants to override the default, he knows if he is
going to use the BIO or REQUEST based multipath. So here is my approach
to avoid introducing another similar looking config keyword:

If we detect minio setting from the config file (either in the
multipath, device or default section), we use it. The code internally
has minio_rq just as you did. In other words, the only change I am
proposing is, use the existing routines that handle minio keyword and
set minio_rq there.

E.g: def_minio_handler() will set conf->minio_rq = conf->minio
hw_minio_handler() will set hwe->minio_rq = hwe->minio
mp_minio_handler() will set mpe->minio_rq = mpe->minio

Thanks, Malahal.
