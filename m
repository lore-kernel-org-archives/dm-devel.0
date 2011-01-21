From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: multipath: change the DEFAULT_MINIO for the request
 based multipath
Date: Fri, 21 Jan 2011 15:46:33 +0100
Message-ID: <1295621193.23625.37.camel@zezette>
References: <91d6dae7d88296d8a1fe.1295472607@malahal>
	<4D37E513.3070506@suse.de> <20110120160726.GA23529@redhat.com>
	<4D392FBD.5080207@ce.jp.nec.com> <1295599627.23625.16.camel@zezette>
	<20110121141204.GE30411@redhat.com>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20110121141204.GE30411@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids


> I'm not following why we'd need a different configuration parameter.
> It is just that the default rr_min_io that would be used would be
> conditional on the multipath target version being >= 1.1.0.
> 
Defaults are layered. For current minio, we have :
[1] one top level default (hardcoded, superseded by config)
[2] per hardware default (hardcoded, superseded by config)
[3] per multipath value (none hardcoded, defined by config)

You suggest multipath-tools to adapt only the top level minio default
depending on dm-rq availability [1], but what of the hwtable defaults
[2] ? Should we provide vendors with a way to describe a with-rq minio
default *and* a without-rq minio default (a new parameter in the hwentry
struct) ? If so, we should also provide a new config file keyword to
override this new hwentry parameter hardcoded value ... then the
reasoning cascades to the mpentry struct minio setting [3].

Actually, [1] is hardly the common case : only unknown hardware resort
to these defaults.

Is my reasoning flawed ?
