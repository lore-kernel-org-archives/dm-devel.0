From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: replace LDFLAGS with
 LIBDEPS for groups of libraries in Makefiles
Date: Fri, 12 Aug 2016 20:33:09 +0200
Message-ID: <fa5e4e49-80ff-e84f-1505-988aad64526f@gmail.com>
References: <1471024973-15047-1-git-send-email-xose.vazquez@gmail.com>
	<3184b48f-d8eb-e73b-795f-6622b6fbf5fa@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <3184b48f-d8eb-e73b-795f-6622b6fbf5fa@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 08/12/2016 08:10 PM, Bart Van Assche wrote:

> It seems like a patch description that motivates why this change is considered useful is missing completely? Anyway, have you considered to use a name that is consistent by what is expected by
> automake, namely LDADD (see also https://www.gnu.org/software/automake/manual/html_node/Linking.html#Linking)?

I followed just same rule as in the rest of multipath-tools'
Makefiles. Where it's called "LIBDEPS":

libmpathpersist/Makefile:LIBDEPS +=  -lpthread -ldevmapper -ldl -L$(multipathdir) -lmultipath \
libmultipath/Makefile:          LIBDEPS += -lsystemd
libmultipath/Makefile:          LIBDEPS += -lsystemd-daemon
