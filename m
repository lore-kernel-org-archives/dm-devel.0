From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH 1/2] multipath-tools: move COPYING to
	COPYING.LESSER
Date: Mon, 9 Apr 2018 19:29:08 +0200
Message-ID: <9ad33b55-17fc-9ed9-ca11-2be0e11a7b1f@gmail.com>
References: <20180327182819.20163-1-xose.vazquez@gmail.com>
	<1523289440.3525.27.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1523289440.3525.27.camel@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 04/09/2018 05:57 PM, Martin Wilck wrote:

> There are >130 files in the multipath-tools source code which don't
> have a license header. So far my *assumption* was that these files were
> covered by COPYING, which used to be LGPLv2.0.

They are under their _original_ licence. Nothing was changed inside
the files.

> By changing COPYING to
> GPLv2.0, you effectively changed the license of all these files from
> LPGLv2.0 to GPLv2.0

There is no evidence of that in any place. All references to the COPYING file are
external files/code, with GPL licence.

$ git grep COPYING

libdmmp/docs/kernel-doc:## Please read the COPYING file for more information             ##
libmultipath/alias.c: * See the file COPYING included with this distribution for more details.
libmultipath/file.c: * See the file COPYING included with this distribution for more details.
third-party/valgrind/drd.h:  otherwise indicated.  See the COPYING file in the source
third-party/valgrind/drd.h:  COPYING file in the source distribution for details.
third-party/valgrind/valgrind.h:   otherwise indicated.  See the COPYING file in the source
third-party/valgrind/valgrind.h:   COPYING file in the source distribution for details.
