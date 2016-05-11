From: Christophe Varoqui <christophe.varoqui@opensvc.com>
Subject: Re: [PATCH v2 1/1] add display of map information in
	JSON format
Date: Wed, 11 May 2016 19:35:37 +0200
Message-ID: <CABr-Gnd1+P8No_7E-ThXwPTUiS-cq0jqTQfh3M3ThOcXbkAd5w@mail.gmail.com>
References: <1462907128-28792-1-git-send-email-tgill@redhat.com>
	<1462907128-28792-2-git-send-email-tgill@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============4364419729564482648=="
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1462907128-28792-2-git-send-email-tgill@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Todd Gill <tgill@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

--===============4364419729564482648==
Content-Type: multipart/alternative; boundary=001a11411da0411b870532947807

--001a11411da0411b870532947807
Content-Type: text/plain; charset=UTF-8

Hi,

the json choice over xml is fine for me, so I'm ready to merge.

Before I do so, is there a second round of review pending ?

Are wannabe users of this new output happy with some fields being merged
(like vendor/product/rev) ?

Best regards,
Christophe Varoqui
OpenSVC


On Tue, May 10, 2016 at 9:05 PM, Todd Gill <tgill@redhat.com> wrote:

> The patch add these commands:
>
> multipathd show maps json
> multipathd show map $map json
>
> Each command will output the requested map(s) in JSON.
>
> For the "show maps json" command, the patch pre-allocates
> INITIAL_REPLY_LEN * PRINT_JSON_MULTIPLIER(5).  The JSON text
> is about 5x the size of the "show maps topology" text.
>
> Signed-off-by: Todd Gill <tgill@redhat.com>
> ---
>  libmultipath/print.c      | 163
> ++++++++++++++++++++++++++++++++++++++++++++++
>  libmultipath/print.h      |  63 ++++++++++++++++++
>  multipathd/cli.c          |   3 +
>  multipathd/cli.h          |   2 +
>  multipathd/cli_handlers.c |  93 ++++++++++++++++++++++++++
>  multipathd/cli_handlers.h |   2 +
>  multipathd/main.c         |   2 +
>  7 files changed, 328 insertions(+)
>
> diff --git a/libmultipath/print.c b/libmultipath/print.c
> index 7fec6e9..e92b534 100644
> --- a/libmultipath/print.c
> +++ b/libmultipath/print.c
> @@ -1000,6 +1000,169 @@ snprint_multipath_topology (char * buff, int len,
> struct multipath * mpp,
>  }
>
>  static int
> +snprint_json (char * line, int len, int indent, char *json_str)
> +{
> +       int fwd = 0, i;
> +
> +       for (i = 0; i < indent; i++) {
> +               fwd += snprintf(line + fwd, len - fwd, PRINT_JSON_INDENT);
> +               if (fwd > len)
> +                       return fwd;
> +       }
> +
> +       fwd += snprintf(line + fwd, len - fwd, "%s", json_str);
> +       return fwd;
> +}
> +
> +static int
> +snprint_json_header (char * line, int len)
> +{
> +       int fwd = 0;
> +
> +       fwd +=  snprint_json(line + fwd, len, 0, PRINT_JSON_START_ELEM);
> +       if (fwd > len)
> +               return fwd;
> +
> +       fwd +=  snprintf(line + fwd, len  - fwd, PRINT_JSON_START_VERSION,
> +                       PRINT_JSON_MAJOR_VERSION,
> PRINT_JSON_MINOR_VERSION);
> +       return fwd;
> +}
> +
> +static int
> +snprint_json_elem_footer (char * line, int len, int indent, int last)
> +{
> +       int fwd = 0, i;
> +
> +       for (i = 0; i < indent; i++) {
> +               fwd += snprintf(line + fwd, len - fwd, PRINT_JSON_INDENT);
> +               if (fwd > len)
> +                       return fwd;
> +       }
> +
> +       if (last == 1)
> +               fwd += snprintf(line + fwd, len - fwd, "%s",
> +                               PRINT_JSON_END_LAST);
> +       else
> +               fwd += snprintf(line + fwd, len - fwd, "%s",
> +                               PRINT_JSON_END_ELEM);
> +       return fwd;
> +}
> +
> +static int
> +snprint_multipath_fields_json (char * buff, int len,
> +               struct multipath * mpp, int last)
> +{
> +       int i, j, fwd = 0;
> +       struct path *pp;
> +       struct pathgroup *pgp;
> +
> +       fwd += snprint_multipath(buff + fwd, len - fwd, PRINT_JSON_MAP,
> mpp, 0);
> +       if (fwd > len)
> +               return fwd;
> +
> +       fwd += snprint_json(buff + fwd, len - fwd, 2,
> PRINT_JSON_START_GROUPS);
> +       if (fwd > len)
> +               return fwd;
> +
> +       vector_foreach_slot (mpp->pg, pgp, i) {
> +
> +               pgp->selector = mpp->selector;
> +               fwd += snprint_pathgroup(buff + fwd, len - fwd,
> PRINT_JSON_GROUP, pgp);
> +               if (fwd > len)
> +                       return fwd;
> +
> +               fwd += snprint_json(buff + fwd, len - fwd, 3,
> PRINT_JSON_START_PATHS);
> +               if (fwd > len)
> +                       return fwd;
> +
> +               vector_foreach_slot (pgp->paths, pp, j) {
> +
> +                       fwd += snprint_path(buff + fwd,
> +                                       len - fwd, PRINT_JSON_PATH, pp, 0);
> +                       if (fwd > len)
> +                               return fwd;
> +
> +                       fwd += snprint_json_elem_footer(buff + fwd,
> +                                       len - fwd, 3, j + 1 ==
> VECTOR_SIZE(pgp->paths));
> +                       if (fwd > len)
> +                               return fwd;
> +               }
> +
> +               fwd += snprint_json(buff + fwd, len - fwd, 0,
> PRINT_JSON_END_ARRAY);
> +               if (fwd > len)
> +                       return fwd;
> +
> +               fwd +=  snprint_json_elem_footer(buff + fwd,
> +                       len - fwd, 2, i + 1 == VECTOR_SIZE(mpp->pg));
> +               if (fwd > len)
> +                       return fwd;
> +       }
> +
> +       fwd += snprint_json(buff + fwd, len - fwd, 0,
> PRINT_JSON_END_ARRAY);
> +       if (fwd > len)
> +               return fwd;
> +
> +       fwd += snprint_json_elem_footer(buff + fwd, len - fwd, 1, last);
> +       return fwd;
> +}
> +
> +int
> +snprint_multipath_map_json (char * buff, int len,
> +               struct multipath * mpp, int last){
> +       int fwd = 0;
> +
> +       memset(buff, 0, len);
> +       fwd +=  snprint_json_header(buff + fwd, len);
> +       if (fwd > len)
> +               return len;
> +
> +       fwd +=  snprint_json(buff + fwd, len - fwd, 0,
> PRINT_JSON_START_MAP);
> +       if (fwd > len)
> +               return len;
> +
> +       fwd += snprint_multipath_fields_json(buff + fwd, len - fwd, mpp,
> 1);
> +       if (fwd > len)
> +               return len;
> +
> +       fwd +=  snprint_json(buff + fwd, len - fwd, 0,
> "\n"PRINT_JSON_END_LAST);
> +       if (fwd > len)
> +               return len;
> +       return fwd;
> +}
> +
> +int
> +snprint_multipath_topology_json (char * buff, int len, struct vectors *
> vecs)
> +{
> +       int i, fwd = 0;
> +       struct multipath * mpp;
> +
> +       memset(buff, 0, len);
> +       fwd +=  snprint_json_header(buff + fwd, len);
> +       if (fwd > len)
> +               return len;
> +
> +       fwd +=  snprint_json(buff + fwd, len  - fwd, 1,
> PRINT_JSON_START_MAPS);
> +       if (fwd > len)
> +               return len;
> +
> +       vector_foreach_slot(vecs->mpvec, mpp, i) {
> +               fwd += snprint_multipath_fields_json(buff + fwd, len - fwd,
> +                               mpp, i + 1 == VECTOR_SIZE(vecs->mpvec));
> +               if (fwd > len)
> +                       return len;
> +       }
> +
> +       fwd +=  snprint_json(buff + fwd, len - fwd, 0,
> PRINT_JSON_END_ARRAY);
> +       if (fwd > len)
> +               return len;
> +
> +       fwd +=  snprint_json(buff + fwd, len - fwd, 0,
> PRINT_JSON_END_LAST);
> +       if (fwd > len)
> +               return len;
> +       return fwd;
> +}
> +
> +static int
>  snprint_hwentry (char * buff, int len, struct hwentry * hwe)
>  {
>         int i;
> diff --git a/libmultipath/print.h b/libmultipath/print.h
> index 8bd0bbc..f8a383d 100644
> --- a/libmultipath/print.h
> +++ b/libmultipath/print.h
> @@ -7,6 +7,65 @@
>  #define PRINT_MAP_PROPS      "size=%S features='%f' hwhandler='%h' wp=%r"
>  #define PRINT_PG_INDENT      "policy='%s' prio=%p status=%t"
>
> +#define PRINT_JSON_MULTIPLIER     5
> +#define PRINT_JSON_MAJOR_VERSION  0
> +#define PRINT_JSON_MINOR_VERSION  1
> +#define PRINT_JSON_START_VERSION  "   \"major_version \": %d,\n" \
> +                                  "   \"minor_version \": %d,\n"
> +#define PRINT_JSON_START_ELEM     "{\n"
> +#define PRINT_JSON_START_MAP      "   \"map\":"
> +#define PRINT_JSON_START_MAPS     "\"maps\": ["
> +#define PRINT_JSON_START_PATHS    "\"paths\": ["
> +#define PRINT_JSON_START_GROUPS   "\"path_groups\": ["
> +#define PRINT_JSON_END_ELEM       "},"
> +#define PRINT_JSON_END_LAST       "}"
> +#define PRINT_JSON_END_ARRAY      "]\n"
> +#define PRINT_JSON_INDENT    "   "
> +#define PRINT_JSON_MAP       "{\n" \
> +                             "      \"name\" : \"%n\",\n" \
> +                             "      \"uuid\" : \"%w\",\n" \
> +                             "      \"sysfs\" : \"%d\",\n" \
> +                             "      \"failback\" : \"%F\",\n" \
> +                             "      \"queueing\" : \"%Q\",\n" \
> +                             "      \"paths\" : %N,\n" \
> +                             "      \"write_prot\" : \"%r\",\n" \
> +                             "      \"dm-st\" : \"%t\",\n" \
> +                             "      \"size\" : \"%S\",\n" \
> +                             "      \"features\" : \"%f\",\n" \
> +                             "      \"hwhandler\" : \"%h\",\n" \
> +                             "      \"action\" : \"%A\",\n" \
> +                             "      \"path_faults\" : %0,\n" \
> +                             "      \"vend/prod/rev\" : \"%s\",\n" \
> +                             "      \"switch_grp\" : %1,\n" \
> +                             "      \"map_loads\" : %2,\n" \
> +                             "      \"total_q_time\" : %3,\n" \
> +                             "      \"q_timeouts\" : %4,"
> +
> +#define PRINT_JSON_GROUP     "{\n" \
> +                             "         \"selector\" : \"%s\",\n" \
> +                             "         \"pri\" : %p,\n" \
> +                             "         \"dm_st\" : \"%t\","
> +
> +#define PRINT_JSON_PATH      "{\n" \
> +                             "            \"uuid\" : \"%w\",\n" \
> +                             "            \"hcil\" : \"%i\",\n" \
> +                             "            \"dev\" : \"%d\",\n"\
> +                             "            \"dev_t\" : \"%D\",\n" \
> +                             "            \"dm_st\" : \"%t\",\n" \
> +                             "            \"dev_st\" : \"%o\",\n" \
> +                             "            \"chk_st\" : \"%T\",\n" \
> +                             "            \"vend/prod/rev\" : \"%s\",\n" \
> +                             "            \"checker\" : \"%c\",\n" \
> +                             "            \"next_check\" : \"%C\",\n" \
> +                             "            \"pri\" : %p,\n" \
> +                             "            \"size\" : \"%S\",\n" \
> +                             "            \"serial\" : \"%z\",\n" \
> +                             "            \"host WWNN\" : \"%N\",\n" \
> +                             "            \"target WWNN\" : \"%n\",\n" \
> +                             "            \"host WWPN\" : \"%R\",\n" \
> +                             "            \"target WWPN\" : \"%r\",\n" \
> +                             "            \"host adapter\" : \"%a\""
> +
>  #define MAX_LINE_LEN  80
>  #define MAX_LINES     64
>  #define MAX_FIELD_LEN 64
> @@ -41,6 +100,10 @@ int snprint_path (char *, int, char *, struct path *,
> int);
>  int snprint_multipath (char *, int, char *, struct multipath *, int);
>  int snprint_multipath_topology (char *, int, struct multipath * mpp,
>                                 int verbosity);
> +int snprint_multipath_topology_json (char * buff, int len,
> +                               struct vectors * vecs);
> +int snprint_multipath_map_json (char * buff, int len,
> +                               struct multipath * mpp, int last);
>  int snprint_defaults (char *, int);
>  int snprint_blacklist (char *, int);
>  int snprint_blacklist_except (char *, int);
> diff --git a/multipathd/cli.c b/multipathd/cli.c
> index d991cd0..20ee3db 100644
> --- a/multipathd/cli.c
> +++ b/multipathd/cli.c
> @@ -207,6 +207,7 @@ load_keys (void)
>         r += add_key(keys, "setprstatus", SETPRSTATUS, 0);
>         r += add_key(keys, "unsetprstatus", UNSETPRSTATUS, 0);
>         r += add_key(keys, "format", FMT, 1);
> +       r += add_key(keys, "json", JSON, 0);
>
>         if (r) {
>                 free_keys(keys);
> @@ -537,8 +538,10 @@ cli_init (void) {
>         add_handler(LIST+MAPS+FMT, NULL);
>         add_handler(LIST+MAPS+RAW+FMT, NULL);
>         add_handler(LIST+MAPS+TOPOLOGY, NULL);
> +       add_handler(LIST+MAPS+JSON, NULL);
>         add_handler(LIST+TOPOLOGY, NULL);
>         add_handler(LIST+MAP+TOPOLOGY, NULL);
> +       add_handler(LIST+MAP+JSON, NULL);
>         add_handler(LIST+MAP+FMT, NULL);
>         add_handler(LIST+MAP+RAW+FMT, NULL);
>         add_handler(LIST+CONFIG, NULL);
> diff --git a/multipathd/cli.h b/multipathd/cli.h
> index 84ca40f..92cb41b 100644
> --- a/multipathd/cli.h
> +++ b/multipathd/cli.h
> @@ -36,6 +36,7 @@ enum {
>         __SETPRSTATUS,
>         __UNSETPRSTATUS,
>         __FMT,
> +       __JSON,
>  };
>
>  #define LIST           (1 << __LIST)
> @@ -74,6 +75,7 @@ enum {
>  #define SETPRSTATUS    (1ULL << __SETPRSTATUS)
>  #define UNSETPRSTATUS  (1ULL << __UNSETPRSTATUS)
>  #define FMT            (1ULL << __FMT)
> +#define JSON           (1ULL << __JSON)
>
>  #define INITIAL_REPLY_LEN      1200
>
> diff --git a/multipathd/cli_handlers.c b/multipathd/cli_handlers.c
> index 8b3cb9d..19cf2ff 100644
> --- a/multipathd/cli_handlers.c
> +++ b/multipathd/cli_handlers.c
> @@ -156,6 +156,70 @@ show_maps_topology (char ** r, int * len, struct
> vectors * vecs)
>  }
>
>  int
> +show_maps_json (char ** r, int * len, struct vectors * vecs)
> +{
> +       int i;
> +       struct multipath * mpp;
> +       char * c;
> +       char * reply;
> +       unsigned int maxlen = INITIAL_REPLY_LEN * PRINT_JSON_MULTIPLIER;
> +       int again = 1;
> +
> +       vector_foreach_slot(vecs->mpvec, mpp, i) {
> +               if (update_multipath(vecs, mpp->alias, 0)) {
> +                       return 1;
> +               }
> +       }
> +
> +       reply = MALLOC(maxlen);
> +
> +       while (again) {
> +               if (!reply)
> +                       return 1;
> +
> +               c = reply;
> +
> +               c += snprint_multipath_topology_json(c, reply + maxlen - c,
> +                               vecs);
> +               again = ((c - reply) == maxlen);
> +
> +               REALLOC_REPLY(reply, again, maxlen);
> +       }
> +       *r = reply;
> +       *len = (int)(c - reply + 1);
> +       return 0;
> +}
> +
> +int
> +show_map_json (char ** r, int * len, struct multipath * mpp,
> +                  struct vectors * vecs)
> +{
> +       char * c;
> +       char * reply;
> +       unsigned int maxlen = INITIAL_REPLY_LEN;
> +       int again = 1;
> +
> +       if (update_multipath(vecs, mpp->alias, 0))
> +               return 1;
> +       reply = MALLOC(maxlen);
> +
> +       while (again) {
> +               if (!reply)
> +                       return 1;
> +
> +               c = reply;
> +
> +               c += snprint_multipath_map_json(c, reply + maxlen - c,
> mpp, 1);
> +               again = ((c - reply) == maxlen);
> +
> +               REALLOC_REPLY(reply, again, maxlen);
> +       }
> +       *r = reply;
> +       *len = (int)(c - reply + 1);
> +       return 0;
> +}
> +
> +int
>  show_config (char ** r, int * len)
>  {
>         char * c;
> @@ -291,6 +355,35 @@ cli_list_maps_topology (void * v, char ** reply, int
> * len, void * data)
>  }
>
>  int
> +cli_list_map_json (void * v, char ** reply, int * len, void * data)
> +{
> +       struct multipath * mpp;
> +       struct vectors * vecs = (struct vectors *)data;
> +       char * param = get_keyparam(v, MAP);
> +
> +       param = convert_dev(param, 0);
> +       get_path_layout(vecs->pathvec, 0);
> +       mpp = find_mp_by_str(vecs->mpvec, param);
> +
> +       if (!mpp)
> +               return 1;
> +
> +       condlog(3, "list multipath json %s (operator)", param);
> +
> +       return show_map_json(reply, len, mpp, vecs);
> +}
> +
> +int
> +cli_list_maps_json (void * v, char ** reply, int * len, void * data)
> +{
> +       struct vectors * vecs = (struct vectors *)data;
> +
> +       condlog(3, "list multipaths json (operator)");
> +
> +       return show_maps_json(reply, len, vecs);
> +}
> +
> +int
>  cli_list_wildcards (void * v, char ** reply, int * len, void * data)
>  {
>         char * c;
> diff --git a/multipathd/cli_handlers.h b/multipathd/cli_handlers.h
> index 5d51018..e838f19 100644
> --- a/multipathd/cli_handlers.h
> +++ b/multipathd/cli_handlers.h
> @@ -13,6 +13,8 @@ int cli_list_maps_status (void * v, char ** reply, int *
> len, void * data);
>  int cli_list_maps_stats (void * v, char ** reply, int * len, void * data);
>  int cli_list_map_topology (void * v, char ** reply, int * len, void *
> data);
>  int cli_list_maps_topology (void * v, char ** reply, int * len, void *
> data);
> +int cli_list_map_json (void * v, char ** reply, int * len, void * data);
> +int cli_list_maps_json (void * v, char ** reply, int * len, void * data);
>  int cli_list_config (void * v, char ** reply, int * len, void * data);
>  int cli_list_blacklist (void * v, char ** reply, int * len, void * data);
>  int cli_list_devices (void * v, char ** reply, int * len, void * data);
> diff --git a/multipathd/main.c b/multipathd/main.c
> index 58e8854..33f38cd 100644
> --- a/multipathd/main.c
> +++ b/multipathd/main.c
> @@ -1120,9 +1120,11 @@ uxlsnrloop (void * ap)
>         set_handler_callback(LIST+MAPS+RAW+FMT, cli_list_maps_raw);
>         set_handler_callback(LIST+MAPS+TOPOLOGY, cli_list_maps_topology);
>         set_handler_callback(LIST+TOPOLOGY, cli_list_maps_topology);
> +       set_handler_callback(LIST+MAPS+JSON, cli_list_maps_json);
>         set_handler_callback(LIST+MAP+TOPOLOGY, cli_list_map_topology);
>         set_handler_callback(LIST+MAP+FMT, cli_list_map_fmt);
>         set_handler_callback(LIST+MAP+RAW+FMT, cli_list_map_fmt);
> +       set_handler_callback(LIST+MAP+JSON, cli_list_map_json);
>         set_unlocked_handler_callback(LIST+CONFIG, cli_list_config);
>         set_unlocked_handler_callback(LIST+BLACKLIST, cli_list_blacklist);
>         set_handler_callback(LIST+DEVICES, cli_list_devices);
> --
> 2.5.5
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>

--001a11411da0411b870532947807
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: base64

PGRpdiBkaXI9Imx0ciI+SGksPGRpdj48YnI+PC9kaXY+PGRpdj50aGUganNvbiBjaG9pY2Ugb3Zl
ciB4bWwgaXMgZmluZSBmb3IgbWUsIHNvIEkmIzM5O20gcmVhZHkgdG8gbWVyZ2UuPC9kaXY+PGRp
dj48YnI+PC9kaXY+PGRpdj5CZWZvcmUgSSBkbyBzbywgaXMgdGhlcmUgYSBzZWNvbmQgcm91bmQg
b2YgcmV2aWV3IHBlbmRpbmcgPzwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+QXJlIHdhbm5hYmUg
dXNlcnMgb2YgdGhpcyBuZXcgb3V0cHV0IGhhcHB5IHdpdGggc29tZSBmaWVsZHMgYmVpbmcgbWVy
Z2VkIChsaWtlIHZlbmRvci9wcm9kdWN0L3JldikgPzwvZGl2PjxkaXY+PGJyPjwvZGl2PjxkaXY+
QmVzdCByZWdhcmRzLDwvZGl2PjxkaXY+Q2hyaXN0b3BoZSBWYXJvcXVpPC9kaXY+PGRpdj5PcGVu
U1ZDPC9kaXY+PGRpdj48YnI+PC9kaXY+PC9kaXY+PGRpdiBjbGFzcz0iZ21haWxfZXh0cmEiPjxi
cj48ZGl2IGNsYXNzPSJnbWFpbF9xdW90ZSI+T24gVHVlLCBNYXkgMTAsIDIwMTYgYXQgOTowNSBQ
TSwgVG9kZCBHaWxsIDxzcGFuIGRpcj0ibHRyIj4mbHQ7PGEgaHJlZj0ibWFpbHRvOnRnaWxsQHJl
ZGhhdC5jb20iIHRhcmdldD0iX2JsYW5rIj50Z2lsbEByZWRoYXQuY29tPC9hPiZndDs8L3NwYW4+
IHdyb3RlOjxicj48YmxvY2txdW90ZSBjbGFzcz0iZ21haWxfcXVvdGUiIHN0eWxlPSJtYXJnaW46
MCAwIDAgLjhleDtib3JkZXItbGVmdDoxcHggI2NjYyBzb2xpZDtwYWRkaW5nLWxlZnQ6MWV4Ij5U
aGUgcGF0Y2ggYWRkIHRoZXNlIGNvbW1hbmRzOjxicj4NCjxicj4NCm11bHRpcGF0aGQgc2hvdyBt
YXBzIGpzb248YnI+DQptdWx0aXBhdGhkIHNob3cgbWFwICRtYXAganNvbjxicj4NCjxicj4NCkVh
Y2ggY29tbWFuZCB3aWxsIG91dHB1dCB0aGUgcmVxdWVzdGVkIG1hcChzKSBpbiBKU09OLjxicj4N
Cjxicj4NCkZvciB0aGUgJnF1b3Q7c2hvdyBtYXBzIGpzb24mcXVvdDsgY29tbWFuZCwgdGhlIHBh
dGNoIHByZS1hbGxvY2F0ZXM8YnI+DQpJTklUSUFMX1JFUExZX0xFTiAqIFBSSU5UX0pTT05fTVVM
VElQTElFUig1KS7CoCBUaGUgSlNPTiB0ZXh0PGJyPg0KaXMgYWJvdXQgNXggdGhlIHNpemUgb2Yg
dGhlICZxdW90O3Nob3cgbWFwcyB0b3BvbG9neSZxdW90OyB0ZXh0Ljxicj4NCjxicj4NClNpZ25l
ZC1vZmYtYnk6IFRvZGQgR2lsbCAmbHQ7PGEgaHJlZj0ibWFpbHRvOnRnaWxsQHJlZGhhdC5jb20i
PnRnaWxsQHJlZGhhdC5jb208L2E+Jmd0Ozxicj4NCi0tLTxicj4NCsKgbGlibXVsdGlwYXRoL3By
aW50LmPCoCDCoCDCoCB8IDE2MyArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrPGJyPg0KwqBsaWJtdWx0aXBhdGgvcHJpbnQuaMKgIMKgIMKgIHzCoCA2MyArKysr
KysrKysrKysrKysrKys8YnI+DQrCoG11bHRpcGF0aGQvY2xpLmPCoCDCoCDCoCDCoCDCoCB8wqAg
wqAzICs8YnI+DQrCoG11bHRpcGF0aGQvY2xpLmjCoCDCoCDCoCDCoCDCoCB8wqAgwqAyICs8YnI+
DQrCoG11bHRpcGF0aGQvY2xpX2hhbmRsZXJzLmMgfMKgIDkzICsrKysrKysrKysrKysrKysrKysr
KysrKysrPGJyPg0KwqBtdWx0aXBhdGhkL2NsaV9oYW5kbGVycy5oIHzCoCDCoDIgKzxicj4NCsKg
bXVsdGlwYXRoZC9tYWluLmPCoCDCoCDCoCDCoCDCoHzCoCDCoDIgKzxicj4NCsKgNyBmaWxlcyBj
aGFuZ2VkLCAzMjggaW5zZXJ0aW9ucygrKTxicj4NCjxicj4NCmRpZmYgLS1naXQgYS9saWJtdWx0
aXBhdGgvcHJpbnQuYyBiL2xpYm11bHRpcGF0aC9wcmludC5jPGJyPg0KaW5kZXggN2ZlYzZlOS4u
ZTkyYjUzNCAxMDA2NDQ8YnI+DQotLS0gYS9saWJtdWx0aXBhdGgvcHJpbnQuYzxicj4NCisrKyBi
L2xpYm11bHRpcGF0aC9wcmludC5jPGJyPg0KQEAgLTEwMDAsNiArMTAwMCwxNjkgQEAgc25wcmlu
dF9tdWx0aXBhdGhfdG9wb2xvZ3kgKGNoYXIgKiBidWZmLCBpbnQgbGVuLCBzdHJ1Y3QgbXVsdGlw
YXRoICogbXBwLDxicj4NCsKgfTxicj4NCjxicj4NCsKgc3RhdGljIGludDxicj4NCitzbnByaW50
X2pzb24gKGNoYXIgKiBsaW5lLCBpbnQgbGVuLCBpbnQgaW5kZW50LCBjaGFyICpqc29uX3N0cik8
YnI+DQorezxicj4NCivCoCDCoCDCoCDCoGludCBmd2QgPSAwLCBpOzxicj4NCis8YnI+DQorwqAg
wqAgwqAgwqBmb3IgKGkgPSAwOyBpICZsdDsgaW5kZW50OyBpKyspIHs8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBmd2QgKz0gc25wcmludGYobGluZSArIGZ3ZCwgbGVuIC0gZndkLCBQUklO
VF9KU09OX0lOREVOVCk7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKGZ3ZCAmZ3Q7
IGxlbik8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gZndk
Ozxicj4NCivCoCDCoCDCoCDCoH08YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgZndkICs9IHNucHJp
bnRmKGxpbmUgKyBmd2QsIGxlbiAtIGZ3ZCwgJnF1b3Q7JXMmcXVvdDssIGpzb25fc3RyKTs8YnI+
DQorwqAgwqAgwqAgwqByZXR1cm4gZndkOzxicj4NCit9PGJyPg0KKzxicj4NCitzdGF0aWMgaW50
PGJyPg0KK3NucHJpbnRfanNvbl9oZWFkZXIgKGNoYXIgKiBsaW5lLCBpbnQgbGVuKTxicj4NCit7
PGJyPg0KK8KgIMKgIMKgIMKgaW50IGZ3ZCA9IDA7PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoGZ3
ZCArPcKgIHNucHJpbnRfanNvbihsaW5lICsgZndkLCBsZW4sIDAsIFBSSU5UX0pTT05fU1RBUlRf
RUxFTSk7PGJyPg0KK8KgIMKgIMKgIMKgaWYgKGZ3ZCAmZ3Q7IGxlbik8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqByZXR1cm4gZndkOzxicj4NCis8YnI+DQorwqAgwqAgwqAgwqBmd2QgKz3C
oCBzbnByaW50ZihsaW5lICsgZndkLCBsZW7CoCAtIGZ3ZCwgUFJJTlRfSlNPTl9TVEFSVF9WRVJT
SU9OLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFBSSU5UX0pTT05f
TUFKT1JfVkVSU0lPTiwgUFJJTlRfSlNPTl9NSU5PUl9WRVJTSU9OKTs8YnI+DQorwqAgwqAgwqAg
wqByZXR1cm4gZndkOzxicj4NCit9PGJyPg0KKzxicj4NCitzdGF0aWMgaW50PGJyPg0KK3NucHJp
bnRfanNvbl9lbGVtX2Zvb3RlciAoY2hhciAqIGxpbmUsIGludCBsZW4sIGludCBpbmRlbnQsIGlu
dCBsYXN0KTxicj4NCit7PGJyPg0KK8KgIMKgIMKgIMKgaW50IGZ3ZCA9IDAsIGk7PGJyPg0KKzxi
cj4NCivCoCDCoCDCoCDCoGZvciAoaSA9IDA7IGkgJmx0OyBpbmRlbnQ7IGkrKykgezxicj4NCivC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoGZ3ZCArPSBzbnByaW50ZihsaW5lICsgZndkLCBsZW4gLSBm
d2QsIFBSSU5UX0pTT05fSU5ERU5UKTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAo
ZndkICZndDsgbGVuKTxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJl
dHVybiBmd2Q7PGJyPg0KK8KgIMKgIMKgIMKgfTxicj4NCis8YnI+DQorwqAgwqAgwqAgwqBpZiAo
bGFzdCA9PSAxKTxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGZ3ZCArPSBzbnByaW50Zihs
aW5lICsgZndkLCBsZW4gLSBmd2QsICZxdW90OyVzJnF1b3Q7LDxicj4NCivCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoFBSSU5UX0pTT05fRU5EX0xBU1QpOzxi
cj4NCivCoCDCoCDCoCDCoGVsc2U8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBmd2QgKz0g
c25wcmludGYobGluZSArIGZ3ZCwgbGVuIC0gZndkLCAmcXVvdDslcyZxdW90Oyw8YnI+DQorwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBQUklOVF9KU09OX0VO
RF9FTEVNKTs8YnI+DQorwqAgwqAgwqAgwqByZXR1cm4gZndkOzxicj4NCit9PGJyPg0KKzxicj4N
CitzdGF0aWMgaW50PGJyPg0KK3NucHJpbnRfbXVsdGlwYXRoX2ZpZWxkc19qc29uIChjaGFyICog
YnVmZiwgaW50IGxlbiw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBzdHJ1Y3QgbXVsdGlw
YXRoICogbXBwLCBpbnQgbGFzdCk8YnI+DQorezxicj4NCivCoCDCoCDCoCDCoGludCBpLCBqLCBm
d2QgPSAwOzxicj4NCivCoCDCoCDCoCDCoHN0cnVjdCBwYXRoICpwcDs8YnI+DQorwqAgwqAgwqAg
wqBzdHJ1Y3QgcGF0aGdyb3VwICpwZ3A7PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoGZ3ZCArPSBz
bnByaW50X211bHRpcGF0aChidWZmICsgZndkLCBsZW4gLSBmd2QsIFBSSU5UX0pTT05fTUFQLCBt
cHAsIDApOzxicj4NCivCoCDCoCDCoCDCoGlmIChmd2QgJmd0OyBsZW4pPGJyPg0KK8KgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgcmV0dXJuIGZ3ZDs8YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgZndkICs9
IHNucHJpbnRfanNvbihidWZmICsgZndkLCBsZW4gLSBmd2QsIDIsIFBSSU5UX0pTT05fU1RBUlRf
R1JPVVBTKTs8YnI+DQorwqAgwqAgwqAgwqBpZiAoZndkICZndDsgbGVuKTxicj4NCivCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoHJldHVybiBmd2Q7PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoHZlY3Rv
cl9mb3JlYWNoX3Nsb3QgKG1wcC0mZ3Q7cGcsIHBncCwgaSkgezxicj4NCis8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqBwZ3AtJmd0O3NlbGVjdG9yID0gbXBwLSZndDtzZWxlY3Rvcjs8YnI+
DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBmd2QgKz0gc25wcmludF9wYXRoZ3JvdXAoYnVmZiAr
IGZ3ZCwgbGVuIC0gZndkLCBQUklOVF9KU09OX0dST1VQLCBwZ3ApOzxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoGlmIChmd2QgJmd0OyBsZW4pPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgcmV0dXJuIGZ3ZDs8YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgZndkICs9IHNucHJpbnRfanNvbihidWZmICsgZndkLCBsZW4gLSBmd2QsIDMsIFBSSU5U
X0pTT05fU1RBUlRfUEFUSFMpOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmIChmd2Qg
Jmd0OyBsZW4pPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJu
IGZ3ZDs8YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgdmVjdG9yX2ZvcmVhY2hf
c2xvdCAocGdwLSZndDtwYXRocywgcHAsIGopIHs8YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgZndkICs9IHNucHJpbnRfcGF0aChidWZmICsgZndkLDxicj4N
CivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoGxlbiAtIGZ3ZCwgUFJJTlRfSlNPTl9QQVRILCBwcCwgMCk7PGJyPg0KK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKGZ3ZCAmZ3Q7IGxlbik8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gZndkOzxicj4NCis8
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBmd2QgKz0gc25wcmludF9q
c29uX2VsZW1fZm9vdGVyKGJ1ZmYgKyBmd2QsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbGVuIC0gZndkLCAzLCBqICsgMSA9
PSBWRUNUT1JfU0laRShwZ3AtJmd0O3BhdGhzKSk7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgaWYgKGZ3ZCAmZ3Q7IGxlbik8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gZndkOzxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoH08YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgZndkICs9
IHNucHJpbnRfanNvbihidWZmICsgZndkLCBsZW4gLSBmd2QsIDAsIFBSSU5UX0pTT05fRU5EX0FS
UkFZKTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAoZndkICZndDsgbGVuKTxicj4N
CivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybiBmd2Q7PGJyPg0KKzxi
cj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGZ3ZCArPcKgIHNucHJpbnRfanNvbl9lbGVtX2Zv
b3RlcihidWZmICsgZndkLDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oGxlbiAtIGZ3ZCwgMiwgaSArIDEgPT0gVkVDVE9SX1NJWkUobXBwLSZndDtwZykpOzxicj4NCivC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmIChmd2QgJmd0OyBsZW4pPGJyPg0KK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIGZ3ZDs8YnI+DQorwqAgwqAgwqAgwqB9PGJy
Pg0KKzxicj4NCivCoCDCoCDCoCDCoGZ3ZCArPSBzbnByaW50X2pzb24oYnVmZiArIGZ3ZCwgbGVu
IC0gZndkLCAwLCBQUklOVF9KU09OX0VORF9BUlJBWSk7PGJyPg0KK8KgIMKgIMKgIMKgaWYgKGZ3
ZCAmZ3Q7IGxlbik8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gZndkOzxicj4N
Cis8YnI+DQorwqAgwqAgwqAgwqBmd2QgKz0gc25wcmludF9qc29uX2VsZW1fZm9vdGVyKGJ1ZmYg
KyBmd2QsIGxlbiAtIGZ3ZCwgMSwgbGFzdCk7PGJyPg0KK8KgIMKgIMKgIMKgcmV0dXJuIGZ3ZDs8
YnI+DQorfTxicj4NCis8YnI+DQoraW50PGJyPg0KK3NucHJpbnRfbXVsdGlwYXRoX21hcF9qc29u
IChjaGFyICogYnVmZiwgaW50IGxlbiw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBzdHJ1
Y3QgbXVsdGlwYXRoICogbXBwLCBpbnQgbGFzdCl7PGJyPg0KK8KgIMKgIMKgIMKgaW50IGZ3ZCA9
IDA7PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoG1lbXNldChidWZmLCAwLCBsZW4pOzxicj4NCivC
oCDCoCDCoCDCoGZ3ZCArPcKgIHNucHJpbnRfanNvbl9oZWFkZXIoYnVmZiArIGZ3ZCwgbGVuKTs8
YnI+DQorwqAgwqAgwqAgwqBpZiAoZndkICZndDsgbGVuKTxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoHJldHVybiBsZW47PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoGZ3ZCArPcKgIHNucHJp
bnRfanNvbihidWZmICsgZndkLCBsZW4gLSBmd2QsIDAsIFBSSU5UX0pTT05fU1RBUlRfTUFQKTs8
YnI+DQorwqAgwqAgwqAgwqBpZiAoZndkICZndDsgbGVuKTxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoHJldHVybiBsZW47PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoGZ3ZCArPSBzbnByaW50
X211bHRpcGF0aF9maWVsZHNfanNvbihidWZmICsgZndkLCBsZW4gLSBmd2QsIG1wcCwgMSk7PGJy
Pg0KK8KgIMKgIMKgIMKgaWYgKGZ3ZCAmZ3Q7IGxlbik8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqByZXR1cm4gbGVuOzxicj4NCis8YnI+DQorwqAgwqAgwqAgwqBmd2QgKz3CoCBzbnByaW50
X2pzb24oYnVmZiArIGZ3ZCwgbGVuIC0gZndkLCAwLCAmcXVvdDtcbiZxdW90O1BSSU5UX0pTT05f
RU5EX0xBU1QpOzxicj4NCivCoCDCoCDCoCDCoGlmIChmd2QgJmd0OyBsZW4pPGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIGxlbjs8YnI+DQorwqAgwqAgwqAgwqByZXR1cm4gZndk
Ozxicj4NCit9PGJyPg0KKzxicj4NCitpbnQ8YnI+DQorc25wcmludF9tdWx0aXBhdGhfdG9wb2xv
Z3lfanNvbiAoY2hhciAqIGJ1ZmYsIGludCBsZW4sIHN0cnVjdCB2ZWN0b3JzICogdmVjcyk8YnI+
DQorezxicj4NCivCoCDCoCDCoCDCoGludCBpLCBmd2QgPSAwOzxicj4NCivCoCDCoCDCoCDCoHN0
cnVjdCBtdWx0aXBhdGggKiBtcHA7PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoG1lbXNldChidWZm
LCAwLCBsZW4pOzxicj4NCivCoCDCoCDCoCDCoGZ3ZCArPcKgIHNucHJpbnRfanNvbl9oZWFkZXIo
YnVmZiArIGZ3ZCwgbGVuKTs8YnI+DQorwqAgwqAgwqAgwqBpZiAoZndkICZndDsgbGVuKTxicj4N
CivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybiBsZW47PGJyPg0KKzxicj4NCivCoCDCoCDC
oCDCoGZ3ZCArPcKgIHNucHJpbnRfanNvbihidWZmICsgZndkLCBsZW7CoCAtIGZ3ZCwgMSwgUFJJ
TlRfSlNPTl9TVEFSVF9NQVBTKTs8YnI+DQorwqAgwqAgwqAgwqBpZiAoZndkICZndDsgbGVuKTxi
cj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybiBsZW47PGJyPg0KKzxicj4NCivCoCDC
oCDCoCDCoHZlY3Rvcl9mb3JlYWNoX3Nsb3QodmVjcy0mZ3Q7bXB2ZWMsIG1wcCwgaSkgezxicj4N
CivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGZ3ZCArPSBzbnByaW50X211bHRpcGF0aF9maWVsZHNf
anNvbihidWZmICsgZndkLCBsZW4gLSBmd2QsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgbXBwLCBpICsgMSA9PSBWRUNUT1JfU0laRSh2ZWNzLSZn
dDttcHZlYykpOzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoGlmIChmd2QgJmd0OyBsZW4p
PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIGxlbjs8YnI+
DQorwqAgwqAgwqAgwqB9PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoGZ3ZCArPcKgIHNucHJpbnRf
anNvbihidWZmICsgZndkLCBsZW4gLSBmd2QsIDAsIFBSSU5UX0pTT05fRU5EX0FSUkFZKTs8YnI+
DQorwqAgwqAgwqAgwqBpZiAoZndkICZndDsgbGVuKTxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoHJldHVybiBsZW47PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoGZ3ZCArPcKgIHNucHJpbnRf
anNvbihidWZmICsgZndkLCBsZW4gLSBmd2QsIDAsIFBSSU5UX0pTT05fRU5EX0xBU1QpOzxicj4N
CivCoCDCoCDCoCDCoGlmIChmd2QgJmd0OyBsZW4pPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgcmV0dXJuIGxlbjs8YnI+DQorwqAgwqAgwqAgwqByZXR1cm4gZndkOzxicj4NCit9PGJyPg0K
Kzxicj4NCitzdGF0aWMgaW50PGJyPg0KwqBzbnByaW50X2h3ZW50cnkgKGNoYXIgKiBidWZmLCBp
bnQgbGVuLCBzdHJ1Y3QgaHdlbnRyeSAqIGh3ZSk8YnI+DQrCoHs8YnI+DQrCoCDCoCDCoCDCoCBp
bnQgaTs8YnI+DQpkaWZmIC0tZ2l0IGEvbGlibXVsdGlwYXRoL3ByaW50LmggYi9saWJtdWx0aXBh
dGgvcHJpbnQuaDxicj4NCmluZGV4IDhiZDBiYmMuLmY4YTM4M2QgMTAwNjQ0PGJyPg0KLS0tIGEv
bGlibXVsdGlwYXRoL3ByaW50Lmg8YnI+DQorKysgYi9saWJtdWx0aXBhdGgvcHJpbnQuaDxicj4N
CkBAIC03LDYgKzcsNjUgQEA8YnI+DQrCoCNkZWZpbmUgUFJJTlRfTUFQX1BST1BTwqAgwqAgwqAg
JnF1b3Q7c2l6ZT0lUyBmZWF0dXJlcz0mIzM5OyVmJiMzOTsgaHdoYW5kbGVyPSYjMzk7JWgmIzM5
OyB3cD0lciZxdW90Ozxicj4NCsKgI2RlZmluZSBQUklOVF9QR19JTkRFTlTCoCDCoCDCoCAmcXVv
dDtwb2xpY3k9JiMzOTslcyYjMzk7IHByaW89JXAgc3RhdHVzPSV0JnF1b3Q7PGJyPg0KPGJyPg0K
KyNkZWZpbmUgUFJJTlRfSlNPTl9NVUxUSVBMSUVSwqAgwqAgwqA1PGJyPg0KKyNkZWZpbmUgUFJJ
TlRfSlNPTl9NQUpPUl9WRVJTSU9OwqAgMDxicj4NCisjZGVmaW5lIFBSSU5UX0pTT05fTUlOT1Jf
VkVSU0lPTsKgIDE8YnI+DQorI2RlZmluZSBQUklOVF9KU09OX1NUQVJUX1ZFUlNJT07CoCAmcXVv
dDvCoCDCoFwmcXVvdDttYWpvcl92ZXJzaW9uIFwmcXVvdDs6ICVkLFxuJnF1b3Q7IFw8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgJnF1b3Q7
wqAgwqBcJnF1b3Q7bWlub3JfdmVyc2lvbiBcJnF1b3Q7OiAlZCxcbiZxdW90Ozxicj4NCisjZGVm
aW5lIFBSSU5UX0pTT05fU1RBUlRfRUxFTcKgIMKgIMKgJnF1b3Q7e1xuJnF1b3Q7PGJyPg0KKyNk
ZWZpbmUgUFJJTlRfSlNPTl9TVEFSVF9NQVDCoCDCoCDCoCAmcXVvdDvCoCDCoFwmcXVvdDttYXBc
JnF1b3Q7OiZxdW90Ozxicj4NCisjZGVmaW5lIFBSSU5UX0pTT05fU1RBUlRfTUFQU8KgIMKgIMKg
JnF1b3Q7XCZxdW90O21hcHNcJnF1b3Q7OiBbJnF1b3Q7PGJyPg0KKyNkZWZpbmUgUFJJTlRfSlNP
Tl9TVEFSVF9QQVRIU8KgIMKgICZxdW90O1wmcXVvdDtwYXRoc1wmcXVvdDs6IFsmcXVvdDs8YnI+
DQorI2RlZmluZSBQUklOVF9KU09OX1NUQVJUX0dST1VQU8KgIMKgJnF1b3Q7XCZxdW90O3BhdGhf
Z3JvdXBzXCZxdW90OzogWyZxdW90Ozxicj4NCisjZGVmaW5lIFBSSU5UX0pTT05fRU5EX0VMRU3C
oCDCoCDCoCDCoCZxdW90O30sJnF1b3Q7PGJyPg0KKyNkZWZpbmUgUFJJTlRfSlNPTl9FTkRfTEFT
VMKgIMKgIMKgIMKgJnF1b3Q7fSZxdW90Ozxicj4NCisjZGVmaW5lIFBSSU5UX0pTT05fRU5EX0FS
UkFZwqAgwqAgwqAgJnF1b3Q7XVxuJnF1b3Q7PGJyPg0KKyNkZWZpbmUgUFJJTlRfSlNPTl9JTkRF
TlTCoCDCoCAmcXVvdDvCoCDCoCZxdW90Ozxicj4NCisjZGVmaW5lIFBSSU5UX0pTT05fTUFQwqAg
wqAgwqAgwqAmcXVvdDt7XG4mcXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIFwmcXVvdDtuYW1lXCZxdW90OyA6IFwm
cXVvdDslblwmcXVvdDssXG4mcXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIFwmcXVvdDt1dWlkXCZxdW90OyA6IFwm
cXVvdDsld1wmcXVvdDssXG4mcXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIFwmcXVvdDtzeXNmc1wmcXVvdDsgOiBc
JnF1b3Q7JWRcJnF1b3Q7LFxuJnF1b3Q7IFw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCDCoCDCoCBcJnF1b3Q7ZmFpbGJhY2tcJnF1b3Q7
IDogXCZxdW90OyVGXCZxdW90OyxcbiZxdW90OyBcPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgXCZxdW90O3F1ZXVlaW5nXCZx
dW90OyA6IFwmcXVvdDslUVwmcXVvdDssXG4mcXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIFwmcXVvdDtwYXRoc1wm
cXVvdDsgOiAlTixcbiZxdW90OyBcPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgXCZxdW90O3dyaXRlX3Byb3RcJnF1b3Q7IDog
XCZxdW90OyVyXCZxdW90OyxcbiZxdW90OyBcPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgXCZxdW90O2RtLXN0XCZxdW90OyA6
IFwmcXVvdDsldFwmcXVvdDssXG4mcXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIFwmcXVvdDtzaXplXCZxdW90OyA6
IFwmcXVvdDslU1wmcXVvdDssXG4mcXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIFwmcXVvdDtmZWF0dXJlc1wmcXVv
dDsgOiBcJnF1b3Q7JWZcJnF1b3Q7LFxuJnF1b3Q7IFw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCDCoCDCoCBcJnF1b3Q7aHdoYW5kbGVy
XCZxdW90OyA6IFwmcXVvdDslaFwmcXVvdDssXG4mcXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIFwmcXVvdDthY3Rp
b25cJnF1b3Q7IDogXCZxdW90OyVBXCZxdW90OyxcbiZxdW90OyBcPGJyPg0KK8KgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgXCZxdW90O3Bh
dGhfZmF1bHRzXCZxdW90OyA6ICUwLFxuJnF1b3Q7IFw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCDCoCDCoCBcJnF1b3Q7dmVuZC9wcm9k
L3JldlwmcXVvdDsgOiBcJnF1b3Q7JXNcJnF1b3Q7LFxuJnF1b3Q7IFw8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCDCoCDCoCBcJnF1b3Q7
c3dpdGNoX2dycFwmcXVvdDsgOiAlMSxcbiZxdW90OyBcPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgXCZxdW90O21hcF9sb2Fk
c1wmcXVvdDsgOiAlMixcbiZxdW90OyBcPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgXCZxdW90O3RvdGFsX3FfdGltZVwmcXVv
dDsgOiAlMyxcbiZxdW90OyBcPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgXCZxdW90O3FfdGltZW91dHNcJnF1b3Q7IDogJTQs
JnF1b3Q7PGJyPg0KKzxicj4NCisjZGVmaW5lIFBSSU5UX0pTT05fR1JPVVDCoCDCoCDCoCZxdW90
O3tcbiZxdW90OyBcPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgJnF1b3Q7wqAgwqAgwqAgwqAgwqBcJnF1b3Q7c2VsZWN0b3JcJnF1b3Q7IDogXCZxdW90
OyVzXCZxdW90OyxcbiZxdW90OyBcPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgwqAgwqBcJnF1b3Q7cHJpXCZxdW90OyA6ICVw
LFxuJnF1b3Q7IFw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAmcXVvdDvCoCDCoCDCoCDCoCDCoFwmcXVvdDtkbV9zdFwmcXVvdDsgOiBcJnF1b3Q7JXRc
JnF1b3Q7LCZxdW90Ozxicj4NCis8YnI+DQorI2RlZmluZSBQUklOVF9KU09OX1BBVEjCoCDCoCDC
oCAmcXVvdDt7XG4mcXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIMKgIMKgIMKgIFwmcXVvdDt1dWlkXCZxdW90OyA6
IFwmcXVvdDsld1wmcXVvdDssXG4mcXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIMKgIMKgIMKgIFwmcXVvdDtoY2ls
XCZxdW90OyA6IFwmcXVvdDslaVwmcXVvdDssXG4mcXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIMKgIMKgIMKgIFwm
cXVvdDtkZXZcJnF1b3Q7IDogXCZxdW90OyVkXCZxdW90OyxcbiZxdW90O1w8YnI+DQorwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCDCoCDCoCDCoCDC
oCDCoCBcJnF1b3Q7ZGV2X3RcJnF1b3Q7IDogXCZxdW90OyVEXCZxdW90OyxcbiZxdW90OyBcPGJy
Pg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAg
wqAgwqAgwqAgwqAgwqAgXCZxdW90O2RtX3N0XCZxdW90OyA6IFwmcXVvdDsldFwmcXVvdDssXG4m
cXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCZxdW90O8KgIMKgIMKgIMKgIMKgIMKgIFwmcXVvdDtkZXZfc3RcJnF1b3Q7IDogXCZxdW90OyVv
XCZxdW90OyxcbiZxdW90OyBcPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgwqAgwqAgwqAgXCZxdW90O2Noa19zdFwmcXVvdDsg
OiBcJnF1b3Q7JVRcJnF1b3Q7LFxuJnF1b3Q7IFw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCDCoCDCoCDCoCDCoCDCoCBcJnF1b3Q7dmVu
ZC9wcm9kL3JldlwmcXVvdDsgOiBcJnF1b3Q7JXNcJnF1b3Q7LFxuJnF1b3Q7IFw8YnI+DQorwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVvdDvCoCDCoCDCoCDC
oCDCoCDCoCBcJnF1b3Q7Y2hlY2tlclwmcXVvdDsgOiBcJnF1b3Q7JWNcJnF1b3Q7LFxuJnF1b3Q7
IFw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAmcXVv
dDvCoCDCoCDCoCDCoCDCoCDCoCBcJnF1b3Q7bmV4dF9jaGVja1wmcXVvdDsgOiBcJnF1b3Q7JUNc
JnF1b3Q7LFxuJnF1b3Q7IFw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAmcXVvdDvCoCDCoCDCoCDCoCDCoCDCoCBcJnF1b3Q7cHJpXCZxdW90OyA6ICVw
LFxuJnF1b3Q7IFw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAmcXVvdDvCoCDCoCDCoCDCoCDCoCDCoCBcJnF1b3Q7c2l6ZVwmcXVvdDsgOiBcJnF1b3Q7
JVNcJnF1b3Q7LFxuJnF1b3Q7IFw8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAmcXVvdDvCoCDCoCDCoCDCoCDCoCDCoCBcJnF1b3Q7c2VyaWFsXCZxdW90
OyA6IFwmcXVvdDslelwmcXVvdDssXG4mcXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIMKgIMKgIMKgIFwmcXVvdDto
b3N0IFdXTk5cJnF1b3Q7IDogXCZxdW90OyVOXCZxdW90OyxcbiZxdW90OyBcPGJyPg0KK8KgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgwqAg
wqAgwqAgXCZxdW90O3RhcmdldCBXV05OXCZxdW90OyA6IFwmcXVvdDslblwmcXVvdDssXG4mcXVv
dDsgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZx
dW90O8KgIMKgIMKgIMKgIMKgIMKgIFwmcXVvdDtob3N0IFdXUE5cJnF1b3Q7IDogXCZxdW90OyVS
XCZxdW90OyxcbiZxdW90OyBcPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgIMKgJnF1b3Q7wqAgwqAgwqAgwqAgwqAgwqAgXCZxdW90O3RhcmdldCBXV1BOXCZx
dW90OyA6IFwmcXVvdDslclwmcXVvdDssXG4mcXVvdDsgXDxicj4NCivCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCZxdW90O8KgIMKgIMKgIMKgIMKgIMKgIFwmcXVv
dDtob3N0IGFkYXB0ZXJcJnF1b3Q7IDogXCZxdW90OyVhXCZxdW90OyZxdW90Ozxicj4NCis8YnI+
DQrCoCNkZWZpbmUgTUFYX0xJTkVfTEVOwqAgODA8YnI+DQrCoCNkZWZpbmUgTUFYX0xJTkVTwqAg
wqAgwqA2NDxicj4NCsKgI2RlZmluZSBNQVhfRklFTERfTEVOIDY0PGJyPg0KQEAgLTQxLDYgKzEw
MCwxMCBAQCBpbnQgc25wcmludF9wYXRoIChjaGFyICosIGludCwgY2hhciAqLCBzdHJ1Y3QgcGF0
aCAqLCBpbnQpOzxicj4NCsKgaW50IHNucHJpbnRfbXVsdGlwYXRoIChjaGFyICosIGludCwgY2hh
ciAqLCBzdHJ1Y3QgbXVsdGlwYXRoICosIGludCk7PGJyPg0KwqBpbnQgc25wcmludF9tdWx0aXBh
dGhfdG9wb2xvZ3kgKGNoYXIgKiwgaW50LCBzdHJ1Y3QgbXVsdGlwYXRoICogbXBwLDxicj4NCsKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIGludCB2ZXJib3Np
dHkpOzxicj4NCitpbnQgc25wcmludF9tdWx0aXBhdGhfdG9wb2xvZ3lfanNvbiAoY2hhciAqIGJ1
ZmYsIGludCBsZW4sPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgIMKgIMKgc3RydWN0IHZlY3RvcnMgKiB2ZWNzKTs8YnI+DQoraW50IHNucHJpbnRfbXVsdGlw
YXRoX21hcF9qc29uIChjaGFyICogYnVmZiwgaW50IGxlbiw8YnI+DQorwqAgwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBzdHJ1Y3QgbXVsdGlwYXRoICogbXBwLCBp
bnQgbGFzdCk7PGJyPg0KwqBpbnQgc25wcmludF9kZWZhdWx0cyAoY2hhciAqLCBpbnQpOzxicj4N
CsKgaW50IHNucHJpbnRfYmxhY2tsaXN0IChjaGFyICosIGludCk7PGJyPg0KwqBpbnQgc25wcmlu
dF9ibGFja2xpc3RfZXhjZXB0IChjaGFyICosIGludCk7PGJyPg0KZGlmZiAtLWdpdCBhL211bHRp
cGF0aGQvY2xpLmMgYi9tdWx0aXBhdGhkL2NsaS5jPGJyPg0KaW5kZXggZDk5MWNkMC4uMjBlZTNk
YiAxMDA2NDQ8YnI+DQotLS0gYS9tdWx0aXBhdGhkL2NsaS5jPGJyPg0KKysrIGIvbXVsdGlwYXRo
ZC9jbGkuYzxicj4NCkBAIC0yMDcsNiArMjA3LDcgQEAgbG9hZF9rZXlzICh2b2lkKTxicj4NCsKg
IMKgIMKgIMKgIHIgKz0gYWRkX2tleShrZXlzLCAmcXVvdDtzZXRwcnN0YXR1cyZxdW90OywgU0VU
UFJTVEFUVVMsIDApOzxicj4NCsKgIMKgIMKgIMKgIHIgKz0gYWRkX2tleShrZXlzLCAmcXVvdDt1
bnNldHByc3RhdHVzJnF1b3Q7LCBVTlNFVFBSU1RBVFVTLCAwKTs8YnI+DQrCoCDCoCDCoCDCoCBy
ICs9IGFkZF9rZXkoa2V5cywgJnF1b3Q7Zm9ybWF0JnF1b3Q7LCBGTVQsIDEpOzxicj4NCivCoCDC
oCDCoCDCoHIgKz0gYWRkX2tleShrZXlzLCAmcXVvdDtqc29uJnF1b3Q7LCBKU09OLCAwKTs8YnI+
DQo8YnI+DQrCoCDCoCDCoCDCoCBpZiAocikgezxicj4NCsKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IGZyZWVfa2V5cyhrZXlzKTs8YnI+DQpAQCAtNTM3LDggKzUzOCwxMCBAQCBjbGlfaW5pdCAodm9p
ZCkgezxicj4NCsKgIMKgIMKgIMKgIGFkZF9oYW5kbGVyKExJU1QrTUFQUytGTVQsIE5VTEwpOzxi
cj4NCsKgIMKgIMKgIMKgIGFkZF9oYW5kbGVyKExJU1QrTUFQUytSQVcrRk1ULCBOVUxMKTs8YnI+
DQrCoCDCoCDCoCDCoCBhZGRfaGFuZGxlcihMSVNUK01BUFMrVE9QT0xPR1ksIE5VTEwpOzxicj4N
CivCoCDCoCDCoCDCoGFkZF9oYW5kbGVyKExJU1QrTUFQUytKU09OLCBOVUxMKTs8YnI+DQrCoCDC
oCDCoCDCoCBhZGRfaGFuZGxlcihMSVNUK1RPUE9MT0dZLCBOVUxMKTs8YnI+DQrCoCDCoCDCoCDC
oCBhZGRfaGFuZGxlcihMSVNUK01BUCtUT1BPTE9HWSwgTlVMTCk7PGJyPg0KK8KgIMKgIMKgIMKg
YWRkX2hhbmRsZXIoTElTVCtNQVArSlNPTiwgTlVMTCk7PGJyPg0KwqAgwqAgwqAgwqAgYWRkX2hh
bmRsZXIoTElTVCtNQVArRk1ULCBOVUxMKTs8YnI+DQrCoCDCoCDCoCDCoCBhZGRfaGFuZGxlcihM
SVNUK01BUCtSQVcrRk1ULCBOVUxMKTs8YnI+DQrCoCDCoCDCoCDCoCBhZGRfaGFuZGxlcihMSVNU
K0NPTkZJRywgTlVMTCk7PGJyPg0KZGlmZiAtLWdpdCBhL211bHRpcGF0aGQvY2xpLmggYi9tdWx0
aXBhdGhkL2NsaS5oPGJyPg0KaW5kZXggODRjYTQwZi4uOTJjYjQxYiAxMDA2NDQ8YnI+DQotLS0g
YS9tdWx0aXBhdGhkL2NsaS5oPGJyPg0KKysrIGIvbXVsdGlwYXRoZC9jbGkuaDxicj4NCkBAIC0z
Niw2ICszNiw3IEBAIGVudW0gezxicj4NCsKgIMKgIMKgIMKgIF9fU0VUUFJTVEFUVVMsPGJyPg0K
wqAgwqAgwqAgwqAgX19VTlNFVFBSU1RBVFVTLDxicj4NCsKgIMKgIMKgIMKgIF9fRk1ULDxicj4N
CivCoCDCoCDCoCDCoF9fSlNPTiw8YnI+DQrCoH07PGJyPg0KPGJyPg0KwqAjZGVmaW5lIExJU1TC
oCDCoCDCoCDCoCDCoCDCoCgxICZsdDsmbHQ7IF9fTElTVCk8YnI+DQpAQCAtNzQsNiArNzUsNyBA
QCBlbnVtIHs8YnI+DQrCoCNkZWZpbmUgU0VUUFJTVEFUVVPCoCDCoCAoMVVMTCAmbHQ7Jmx0OyBf
X1NFVFBSU1RBVFVTKTxicj4NCsKgI2RlZmluZSBVTlNFVFBSU1RBVFVTwqAgKDFVTEwgJmx0OyZs
dDsgX19VTlNFVFBSU1RBVFVTKTxicj4NCsKgI2RlZmluZSBGTVTCoCDCoCDCoCDCoCDCoCDCoCAo
MVVMTCAmbHQ7Jmx0OyBfX0ZNVCk8YnI+DQorI2RlZmluZSBKU09OwqAgwqAgwqAgwqAgwqAgwqAo
MVVMTCAmbHQ7Jmx0OyBfX0pTT04pPGJyPg0KPGJyPg0KwqAjZGVmaW5lIElOSVRJQUxfUkVQTFlf
TEVOwqAgwqAgwqAgMTIwMDxicj4NCjxicj4NCmRpZmYgLS1naXQgYS9tdWx0aXBhdGhkL2NsaV9o
YW5kbGVycy5jIGIvbXVsdGlwYXRoZC9jbGlfaGFuZGxlcnMuYzxicj4NCmluZGV4IDhiM2NiOWQu
LjE5Y2YyZmYgMTAwNjQ0PGJyPg0KLS0tIGEvbXVsdGlwYXRoZC9jbGlfaGFuZGxlcnMuYzxicj4N
CisrKyBiL211bHRpcGF0aGQvY2xpX2hhbmRsZXJzLmM8YnI+DQpAQCAtMTU2LDYgKzE1Niw3MCBA
QCBzaG93X21hcHNfdG9wb2xvZ3kgKGNoYXIgKiogciwgaW50ICogbGVuLCBzdHJ1Y3QgdmVjdG9y
cyAqIHZlY3MpPGJyPg0KwqB9PGJyPg0KPGJyPg0KwqBpbnQ8YnI+DQorc2hvd19tYXBzX2pzb24g
KGNoYXIgKiogciwgaW50ICogbGVuLCBzdHJ1Y3QgdmVjdG9ycyAqIHZlY3MpPGJyPg0KK3s8YnI+
DQorwqAgwqAgwqAgwqBpbnQgaTs8YnI+DQorwqAgwqAgwqAgwqBzdHJ1Y3QgbXVsdGlwYXRoICog
bXBwOzxicj4NCivCoCDCoCDCoCDCoGNoYXIgKiBjOzxicj4NCivCoCDCoCDCoCDCoGNoYXIgKiBy
ZXBseTs8YnI+DQorwqAgwqAgwqAgwqB1bnNpZ25lZCBpbnQgbWF4bGVuID0gSU5JVElBTF9SRVBM
WV9MRU4gKiBQUklOVF9KU09OX01VTFRJUExJRVI7PGJyPg0KK8KgIMKgIMKgIMKgaW50IGFnYWlu
ID0gMTs8YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgdmVjdG9yX2ZvcmVhY2hfc2xvdCh2ZWNzLSZn
dDttcHZlYywgbXBwLCBpKSB7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKHVwZGF0
ZV9tdWx0aXBhdGgodmVjcywgbXBwLSZndDthbGlhcywgMCkpIHs8YnI+DQorwqAgwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gMTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAg
wqAgwqB9PGJyPg0KK8KgIMKgIMKgIMKgfTxicj4NCis8YnI+DQorwqAgwqAgwqAgwqByZXBseSA9
IE1BTExPQyhtYXhsZW4pOzxicj4NCis8YnI+DQorwqAgwqAgwqAgwqB3aGlsZSAoYWdhaW4pIHs8
YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBpZiAoIXJlcGx5KTxicj4NCivCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybiAxOzxicj4NCis8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBjID0gcmVwbHk7PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoGMgKz0gc25wcmludF9tdWx0aXBhdGhfdG9wb2xvZ3lfanNvbihjLCByZXBseSArIG1heGxl
biAtIGMsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgdmVjcyk7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgYWdhaW4gPSAoKGMgLSByZXBs
eSkgPT0gbWF4bGVuKTs8YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgUkVBTExP
Q19SRVBMWShyZXBseSwgYWdhaW4sIG1heGxlbik7PGJyPg0KK8KgIMKgIMKgIMKgfTxicj4NCivC
oCDCoCDCoCDCoCpyID0gcmVwbHk7PGJyPg0KK8KgIMKgIMKgIMKgKmxlbiA9IChpbnQpKGMgLSBy
ZXBseSArIDEpOzxicj4NCivCoCDCoCDCoCDCoHJldHVybiAwOzxicj4NCit9PGJyPg0KKzxicj4N
CitpbnQ8YnI+DQorc2hvd19tYXBfanNvbiAoY2hhciAqKiByLCBpbnQgKiBsZW4sIHN0cnVjdCBt
dWx0aXBhdGggKiBtcHAsPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIHN0cnVjdCB2
ZWN0b3JzICogdmVjcyk8YnI+DQorezxicj4NCivCoCDCoCDCoCDCoGNoYXIgKiBjOzxicj4NCivC
oCDCoCDCoCDCoGNoYXIgKiByZXBseTs8YnI+DQorwqAgwqAgwqAgwqB1bnNpZ25lZCBpbnQgbWF4
bGVuID0gSU5JVElBTF9SRVBMWV9MRU47PGJyPg0KK8KgIMKgIMKgIMKgaW50IGFnYWluID0gMTs8
YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgaWYgKHVwZGF0ZV9tdWx0aXBhdGgodmVjcywgbXBwLSZn
dDthbGlhcywgMCkpPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgcmV0dXJuIDE7PGJyPg0K
K8KgIMKgIMKgIMKgcmVwbHkgPSBNQUxMT0MobWF4bGVuKTs8YnI+DQorPGJyPg0KK8KgIMKgIMKg
IMKgd2hpbGUgKGFnYWluKSB7PGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgaWYgKCFyZXBs
eSk8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqAgwqByZXR1cm4gMTs8YnI+
DQorPGJyPg0KK8KgIMKgIMKgIMKgIMKgIMKgIMKgIMKgYyA9IHJlcGx5Ozxicj4NCis8YnI+DQor
wqAgwqAgwqAgwqAgwqAgwqAgwqAgwqBjICs9IHNucHJpbnRfbXVsdGlwYXRoX21hcF9qc29uKGMs
IHJlcGx5ICsgbWF4bGVuIC0gYywgbXBwLCAxKTs8YnI+DQorwqAgwqAgwqAgwqAgwqAgwqAgwqAg
wqBhZ2FpbiA9ICgoYyAtIHJlcGx5KSA9PSBtYXhsZW4pOzxicj4NCis8YnI+DQorwqAgwqAgwqAg
wqAgwqAgwqAgwqAgwqBSRUFMTE9DX1JFUExZKHJlcGx5LCBhZ2FpbiwgbWF4bGVuKTs8YnI+DQor
wqAgwqAgwqAgwqB9PGJyPg0KK8KgIMKgIMKgIMKgKnIgPSByZXBseTs8YnI+DQorwqAgwqAgwqAg
wqAqbGVuID0gKGludCkoYyAtIHJlcGx5ICsgMSk7PGJyPg0KK8KgIMKgIMKgIMKgcmV0dXJuIDA7
PGJyPg0KK308YnI+DQorPGJyPg0KK2ludDxicj4NCsKgc2hvd19jb25maWcgKGNoYXIgKiogciwg
aW50ICogbGVuKTxicj4NCsKgezxicj4NCsKgIMKgIMKgIMKgIGNoYXIgKiBjOzxicj4NCkBAIC0y
OTEsNiArMzU1LDM1IEBAIGNsaV9saXN0X21hcHNfdG9wb2xvZ3kgKHZvaWQgKiB2LCBjaGFyICoq
IHJlcGx5LCBpbnQgKiBsZW4sIHZvaWQgKiBkYXRhKTxicj4NCsKgfTxicj4NCjxicj4NCsKgaW50
PGJyPg0KK2NsaV9saXN0X21hcF9qc29uICh2b2lkICogdiwgY2hhciAqKiByZXBseSwgaW50ICog
bGVuLCB2b2lkICogZGF0YSk8YnI+DQorezxicj4NCivCoCDCoCDCoCDCoHN0cnVjdCBtdWx0aXBh
dGggKiBtcHA7PGJyPg0KK8KgIMKgIMKgIMKgc3RydWN0IHZlY3RvcnMgKiB2ZWNzID0gKHN0cnVj
dCB2ZWN0b3JzICopZGF0YTs8YnI+DQorwqAgwqAgwqAgwqBjaGFyICogcGFyYW0gPSBnZXRfa2V5
cGFyYW0odiwgTUFQKTs8YnI+DQorPGJyPg0KK8KgIMKgIMKgIMKgcGFyYW0gPSBjb252ZXJ0X2Rl
dihwYXJhbSwgMCk7PGJyPg0KK8KgIMKgIMKgIMKgZ2V0X3BhdGhfbGF5b3V0KHZlY3MtJmd0O3Bh
dGh2ZWMsIDApOzxicj4NCivCoCDCoCDCoCDCoG1wcCA9IGZpbmRfbXBfYnlfc3RyKHZlY3MtJmd0
O21wdmVjLCBwYXJhbSk7PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoGlmICghbXBwKTxicj4NCivC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoHJldHVybiAxOzxicj4NCis8YnI+DQorwqAgwqAgwqAgwqBj
b25kbG9nKDMsICZxdW90O2xpc3QgbXVsdGlwYXRoIGpzb24gJXMgKG9wZXJhdG9yKSZxdW90Oywg
cGFyYW0pOzxicj4NCis8YnI+DQorwqAgwqAgwqAgwqByZXR1cm4gc2hvd19tYXBfanNvbihyZXBs
eSwgbGVuLCBtcHAsIHZlY3MpOzxicj4NCit9PGJyPg0KKzxicj4NCitpbnQ8YnI+DQorY2xpX2xp
c3RfbWFwc19qc29uICh2b2lkICogdiwgY2hhciAqKiByZXBseSwgaW50ICogbGVuLCB2b2lkICog
ZGF0YSk8YnI+DQorezxicj4NCivCoCDCoCDCoCDCoHN0cnVjdCB2ZWN0b3JzICogdmVjcyA9IChz
dHJ1Y3QgdmVjdG9ycyAqKWRhdGE7PGJyPg0KKzxicj4NCivCoCDCoCDCoCDCoGNvbmRsb2coMywg
JnF1b3Q7bGlzdCBtdWx0aXBhdGhzIGpzb24gKG9wZXJhdG9yKSZxdW90Oyk7PGJyPg0KKzxicj4N
CivCoCDCoCDCoCDCoHJldHVybiBzaG93X21hcHNfanNvbihyZXBseSwgbGVuLCB2ZWNzKTs8YnI+
DQorfTxicj4NCis8YnI+DQoraW50PGJyPg0KwqBjbGlfbGlzdF93aWxkY2FyZHMgKHZvaWQgKiB2
LCBjaGFyICoqIHJlcGx5LCBpbnQgKiBsZW4sIHZvaWQgKiBkYXRhKTxicj4NCsKgezxicj4NCsKg
IMKgIMKgIMKgIGNoYXIgKiBjOzxicj4NCmRpZmYgLS1naXQgYS9tdWx0aXBhdGhkL2NsaV9oYW5k
bGVycy5oIGIvbXVsdGlwYXRoZC9jbGlfaGFuZGxlcnMuaDxicj4NCmluZGV4IDVkNTEwMTguLmU4
MzhmMTkgMTAwNjQ0PGJyPg0KLS0tIGEvbXVsdGlwYXRoZC9jbGlfaGFuZGxlcnMuaDxicj4NCisr
KyBiL211bHRpcGF0aGQvY2xpX2hhbmRsZXJzLmg8YnI+DQpAQCAtMTMsNiArMTMsOCBAQCBpbnQg
Y2xpX2xpc3RfbWFwc19zdGF0dXMgKHZvaWQgKiB2LCBjaGFyICoqIHJlcGx5LCBpbnQgKiBsZW4s
IHZvaWQgKiBkYXRhKTs8YnI+DQrCoGludCBjbGlfbGlzdF9tYXBzX3N0YXRzICh2b2lkICogdiwg
Y2hhciAqKiByZXBseSwgaW50ICogbGVuLCB2b2lkICogZGF0YSk7PGJyPg0KwqBpbnQgY2xpX2xp
c3RfbWFwX3RvcG9sb2d5ICh2b2lkICogdiwgY2hhciAqKiByZXBseSwgaW50ICogbGVuLCB2b2lk
ICogZGF0YSk7PGJyPg0KwqBpbnQgY2xpX2xpc3RfbWFwc190b3BvbG9neSAodm9pZCAqIHYsIGNo
YXIgKiogcmVwbHksIGludCAqIGxlbiwgdm9pZCAqIGRhdGEpOzxicj4NCitpbnQgY2xpX2xpc3Rf
bWFwX2pzb24gKHZvaWQgKiB2LCBjaGFyICoqIHJlcGx5LCBpbnQgKiBsZW4sIHZvaWQgKiBkYXRh
KTs8YnI+DQoraW50IGNsaV9saXN0X21hcHNfanNvbiAodm9pZCAqIHYsIGNoYXIgKiogcmVwbHks
IGludCAqIGxlbiwgdm9pZCAqIGRhdGEpOzxicj4NCsKgaW50IGNsaV9saXN0X2NvbmZpZyAodm9p
ZCAqIHYsIGNoYXIgKiogcmVwbHksIGludCAqIGxlbiwgdm9pZCAqIGRhdGEpOzxicj4NCsKgaW50
IGNsaV9saXN0X2JsYWNrbGlzdCAodm9pZCAqIHYsIGNoYXIgKiogcmVwbHksIGludCAqIGxlbiwg
dm9pZCAqIGRhdGEpOzxicj4NCsKgaW50IGNsaV9saXN0X2RldmljZXMgKHZvaWQgKiB2LCBjaGFy
ICoqIHJlcGx5LCBpbnQgKiBsZW4sIHZvaWQgKiBkYXRhKTs8YnI+DQpkaWZmIC0tZ2l0IGEvbXVs
dGlwYXRoZC9tYWluLmMgYi9tdWx0aXBhdGhkL21haW4uYzxicj4NCmluZGV4IDU4ZTg4NTQuLjMz
ZjM4Y2QgMTAwNjQ0PGJyPg0KLS0tIGEvbXVsdGlwYXRoZC9tYWluLmM8YnI+DQorKysgYi9tdWx0
aXBhdGhkL21haW4uYzxicj4NCkBAIC0xMTIwLDkgKzExMjAsMTEgQEAgdXhsc25ybG9vcCAodm9p
ZCAqIGFwKTxicj4NCsKgIMKgIMKgIMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKExJU1QrTUFQUytS
QVcrRk1ULCBjbGlfbGlzdF9tYXBzX3Jhdyk7PGJyPg0KwqAgwqAgwqAgwqAgc2V0X2hhbmRsZXJf
Y2FsbGJhY2soTElTVCtNQVBTK1RPUE9MT0dZLCBjbGlfbGlzdF9tYXBzX3RvcG9sb2d5KTs8YnI+
DQrCoCDCoCDCoCDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhMSVNUK1RPUE9MT0dZLCBjbGlfbGlz
dF9tYXBzX3RvcG9sb2d5KTs8YnI+DQorwqAgwqAgwqAgwqBzZXRfaGFuZGxlcl9jYWxsYmFjayhM
SVNUK01BUFMrSlNPTiwgY2xpX2xpc3RfbWFwc19qc29uKTs8YnI+DQrCoCDCoCDCoCDCoCBzZXRf
aGFuZGxlcl9jYWxsYmFjayhMSVNUK01BUCtUT1BPTE9HWSwgY2xpX2xpc3RfbWFwX3RvcG9sb2d5
KTs8YnI+DQrCoCDCoCDCoCDCoCBzZXRfaGFuZGxlcl9jYWxsYmFjayhMSVNUK01BUCtGTVQsIGNs
aV9saXN0X21hcF9mbXQpOzxicj4NCsKgIMKgIMKgIMKgIHNldF9oYW5kbGVyX2NhbGxiYWNrKExJ
U1QrTUFQK1JBVytGTVQsIGNsaV9saXN0X21hcF9mbXQpOzxicj4NCivCoCDCoCDCoCDCoHNldF9o
YW5kbGVyX2NhbGxiYWNrKExJU1QrTUFQK0pTT04sIGNsaV9saXN0X21hcF9qc29uKTs8YnI+DQrC
oCDCoCDCoCDCoCBzZXRfdW5sb2NrZWRfaGFuZGxlcl9jYWxsYmFjayhMSVNUK0NPTkZJRywgY2xp
X2xpc3RfY29uZmlnKTs8YnI+DQrCoCDCoCDCoCDCoCBzZXRfdW5sb2NrZWRfaGFuZGxlcl9jYWxs
YmFjayhMSVNUK0JMQUNLTElTVCwgY2xpX2xpc3RfYmxhY2tsaXN0KTs8YnI+DQrCoCDCoCDCoCDC
oCBzZXRfaGFuZGxlcl9jYWxsYmFjayhMSVNUK0RFVklDRVMsIGNsaV9saXN0X2RldmljZXMpOzxi
cj4NCjxzcGFuIGNsYXNzPSJIT0VuWmIiPjxmb250IGNvbG9yPSIjODg4ODg4Ij4tLTxicj4NCjIu
NS41PGJyPg0KPGJyPg0KLS08YnI+DQpkbS1kZXZlbCBtYWlsaW5nIGxpc3Q8YnI+DQo8YSBocmVm
PSJtYWlsdG86ZG0tZGV2ZWxAcmVkaGF0LmNvbSI+ZG0tZGV2ZWxAcmVkaGF0LmNvbTwvYT48YnI+
DQo8YSBocmVmPSJodHRwczovL3d3dy5yZWRoYXQuY29tL21haWxtYW4vbGlzdGluZm8vZG0tZGV2
ZWwiIHJlbD0ibm9yZWZlcnJlciIgdGFyZ2V0PSJfYmxhbmsiPmh0dHBzOi8vd3d3LnJlZGhhdC5j
b20vbWFpbG1hbi9saXN0aW5mby9kbS1kZXZlbDwvYT48YnI+DQo8L2ZvbnQ+PC9zcGFuPjwvYmxv
Y2txdW90ZT48L2Rpdj48YnI+PC9kaXY+DQo=
--001a11411da0411b870532947807--


--===============4364419729564482648==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============4364419729564482648==--
