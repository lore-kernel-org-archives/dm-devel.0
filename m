From: Todd Gill <tgill@redhat.com>
Subject: D-Bus API for multipath
Date: Tue, 01 Sep 2015 12:02:34 -0400
Message-ID: <55E5CC1A.90002@redhat.com>
Reply-To: tgill@redhat.com, device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
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


Currently higher level tools like PostgreSQL, OpenStack/Cinder, Cockpit,
Gnome Disk Utility, Gluster and Ceph don't have easy access to
information about multipath devices.  Providing higher level tools the
ability to visually display/understand multipath setup and health would
be a big help.

Tools currently need to parse the output of the CLI to determine the
mapping from a /dev/mapper/xx to the corresponding /dev/sdxx.  Parsing
CLI output is prone to problems and can be brittle over time.  It also
doesn't deal well with state updates as clients need to poll for changes.

D-Bus is the most common IPC mechanism for the expected consumers of the
API.  D-bus also provides fine granularity of API access security, which
will be more important when configuration change functionality is
introduced into the API.

Proposed Initial Features of D-Bus API:

- Read only attributes and relationships for map, path group and path
- Read only attributes of multipath (blacklist, friendly names etc)
- Signals for path properties (failure, restore)
- Signals for map properties failure (failure, restore, policy change)

Subsequent phases could include the ability to setup and manage features
of multipath.

My impression is this should be done as an extension to the multipathd.
 The d-bus interface could be disabled by default and enabled with a
change to the .conf file setting.

Other approaches may be possible, such the addition of an API to
libmultipath, and accessing that with a some other daemon, like
storaged, but that sort of thing would be less direct than doing it in
multipathd.  An additional API to libmultipath also doesn't solve event
driven state updates in a language agnostic way.

There is also an existing socket into multipathd and that solves some
issues, but raises others.  Talking over a socket home-brewed protocol
requires clients to write code to parsing/marshaling, re-invent
security etc.

I am looking for feedback on this before I get started on an
implementation. Do you agree that a D-Bus interface for multipaththd is
is the most appropriate approach to this problem?
