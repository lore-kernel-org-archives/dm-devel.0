From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] multipath-tools: add CFLAGS to compilation
 options for prioritizers and checkers
Date: Tue, 6 Dec 2016 15:26:04 +0100
Message-ID: <4605234d-c1e0-61e4-fe5c-ad229978f0ee@gmail.com>
References: <20161126222649.29409-1-xose.vazquez@gmail.com>
	<BLUPR02MB16833109A27B319E7E1F319281880@BLUPR02MB1683.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <BLUPR02MB16833109A27B319E7E1F319281880@BLUPR02MB1683.namprd02.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Bart Van Assche <Bart.VanAssche@sandisk.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 11/27/2016 12:00 AM, Bart Van Assche wrote:

> On 11/26/16 14:26, Xose Vazquez Perez wrote:

>> Is there anything else missing or leftover?

>> $ git grep "(CC)"
>> Makefile.inc:   $(CC) $(CFLAGS) -c -o $@ $<
>> kpartx/Makefile:        $(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)

->>> libmpathcmd/Makefile:   $(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS) $(LIBDEPS)

>> libmpathpersist/Makefile:       $(CC) -c $(CFLAGS) *.c

->>> libmpathpersist/Makefile:       $(CC) $(LDFLAGS) $(SHARED_FLAGS) $(LIBDEPS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS)
->>> libmultipath/Makefile:  $(CC) $(LDFLAGS) $(SHARED_FLAGS) -Wl,-soname=$@ $(CFLAGS) -o $@ $(OBJS) $(LIBDEPS)

>> libmultipath/checkers/Makefile: $(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -lrados -ludev
>> libmultipath/checkers/Makefile: $(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^ -laio
>> libmultipath/checkers/Makefile: $(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
>> libmultipath/prioritizers/Makefile:     $(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
>> libmultipath/prioritizers/Makefile:     $(CC) $(CFLAGS) $(LDFLAGS) $(SHARED_FLAGS) -o $@ $^
>> mpathpersist/Makefile:  $(CC) $(OBJS) -o $(EXEC) $(LDFLAGS) $(CFLAGS) $(LIBDEPS)
>> multipath/Makefile:     $(CC) $(CFLAGS) $(OBJS) -o $(EXEC) $(LDFLAGS) $(LIBDEPS)
>> multipathd/Makefile:    $(CC) $(CFLAGS) $(OBJS) $(LDFLAGS) -o $(EXEC) $(LIBDEPS)
>> [...]

> What is the purpose of this patch and why do you think it is useful? It 
> is already possible to specify flags for linking shared libraries 
> through LDFLAGS. I don't see why CFLAGS should be added to the shared 
> library creation commands. Additionally, automake also ignores CFLAGS 
> when linking shared libraries. See also 
> https://www.gnu.org/software/automake/manual/html_node/Libtool-Flags.html#Libtool-Flags.

You are right.

I sent a patch to delete CFLAGS from the libmpathcmd, libmultipath and
libmpathpersist compilation flags.

Thanks for the review.
