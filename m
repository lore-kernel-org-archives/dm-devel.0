From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipath: change the DEFAULT_MINIO for the request
 based multipath
Date: Fri, 21 Jan 2011 09:47:07 +0100
Message-ID: <1295599627.23625.16.camel@zezette>
References: <91d6dae7d88296d8a1fe.1295472607@malahal>
	<4D37E513.3070506@suse.de> <20110120160726.GA23529@redhat.com>
	<4D392FBD.5080207@ce.jp.nec.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4D392FBD.5080207@ce.jp.nec.com>
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
List-Id: dm-devel.ids


> 
> Fortunately, the target version of multipath was also bumped
> in 2.6.31, from 1.0.5 to 1.1.0 by this commit:
> 
> af4874e v2.6.31-rc1 dm target:s introduce iterate devices fn
> 
Fortunate indeed.

Should the 'minio' be a tunable in the request-based multipath context,
or should we hardcode its value to '1' ?

If we keep it a tunable, I guess we'll have to introduce a different
'minio' configuration parameter ('rr_min_io_rq' for example) to permit
vendors to set their defaults for distributions shipping a rq-capable
kernel or not. This change would be pretty invasive.

Please advise.
-- 
Christophe Varoqui <christophe.varoqui@opensvc.com>
OpenSVC
